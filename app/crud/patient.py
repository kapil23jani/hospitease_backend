from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload, selectinload
from app.models.patient import Patient
from app.models.hospital import Hospital
from app.schemas.patient import PatientCreate, PatientUpdate, PatientResponse
import uuid
from datetime import datetime, timedelta
from sqlalchemy import text, and_, or_
from typing import List
import random
from app.models.appointment import Appointment
from app.utils.mail import send_mail
from app.utils.sms import send_sms
import logging
import openai
import os

openai_api_key = os.getenv("OPENAI_API_KEY")
client = openai.OpenAI(api_key=openai_api_key)

async def get_patients(
    db: AsyncSession,
    search: str = None,
    gender: str = None,
    ageRange: str = None,
    minAge: int = None,
    maxAge: int = None,
    blood_group: str = None,
    status: str = None,
    doctor: str = None
):
    query = select(Patient).options(joinedload(Patient.hospital))

    if search:
        search = search.strip()
        query = query.filter(
            or_(
                Patient.first_name.ilike(f"%{search}%"),
                Patient.last_name.ilike(f"%{search}%"),
                Patient.patient_unique_id.ilike(f"%{search}%")
            )
        )


    if gender:
        query = query.filter(Patient.gender == gender)


    if blood_group:
        query = query.filter(Patient.blood_group == blood_group)


    if status:
        query = query.filter(Patient.status == status)


    today = datetime.today()
    if ageRange and "-" in ageRange:
        min_age, max_age = map(int, ageRange.split("-"))
        min_dob = today - timedelta(days=max_age * 365)
        max_dob = today - timedelta(days=min_age * 365)
        query = query.filter(Patient.date_of_birth >= min_dob.strftime("%Y-%m-%d"),
                             Patient.date_of_birth <= max_dob.strftime("%Y-%m-%d"))
    else:
    
        if minAge is not None:
            max_dob = today - timedelta(days=minAge * 365)
            query = query.filter(Patient.date_of_birth <= max_dob.strftime("%Y-%m-%d"))
        if maxAge is not None:
            min_dob = today - timedelta(days=maxAge * 365)
            query = query.filter(Patient.date_of_birth >= min_dob.strftime("%Y-%m-%d"))

    if doctor:
        from app.models.doctor import Doctor
        query = query.join(Doctor, Patient.doctor_id == Doctor.id).filter(
            or_(
                Doctor.first_name.ilike(f"%{doctor}%"),
                Doctor.last_name.ilike(f"%{doctor}%"),
                (Doctor.first_name + " " + Doctor.last_name).ilike(f"%{doctor}%")
            )
        )

    result = await db.execute(query)
    patients = result.scalars().all()
    return [PatientResponse.model_validate(patient) for patient in patients]

async def get_patient(db: AsyncSession, patient_id: int):
    result = await db.execute(select(Patient).filter(Patient.id == patient_id))
    patient = result.scalars().first()
    return PatientResponse.model_validate(patient) if patient else None

async def create_patient(db: AsyncSession, patient_data: PatientCreate):
    result = await db.execute(
        text("SELECT patient_unique_id FROM patients ORDER BY id DESC LIMIT 1")
    )
    last_id = result.scalar()
    if last_id and last_id.isdigit():
        new_patient_id = str(int(last_id) + 1)
    else:
        new_patient_id = "10001"

    while True:
        exists = await db.execute(select(Patient).filter(Patient.patient_unique_id == new_patient_id))
        if not exists.scalar():
            break

    while True:
        mrd_number = random.randint(10**14, 10**15 - 1)
        exists = await db.execute(select(Patient).filter(Patient.mrd_number == mrd_number))
        if not exists.scalar():
            break

    patient_dict = patient_data.model_dump()
    patient_dict["patient_unique_id"] = new_patient_id
    patient_dict["mrd_number"] = mrd_number

    new_patient = Patient(**patient_dict)
    db.add(new_patient)
    await db.commit()
    await db.refresh(new_patient)

    if new_patient.email:
        logging.info(f"Attempting to send welcome email to {new_patient.email}")
        mail_result = send_mail(
            to_email=new_patient.email,
            subject="Welcome to Hospitease!",
            html_content=f"""
                <h2>Welcome, {new_patient.first_name}!</h2>
                <p>Your registration is successful. Your Patient ID is <b>{new_patient.patient_unique_id}</b>.</p>
                <p>Thank you for choosing Hospitease.</p>
            """
        )
        logging.info(f"SendGrid mail result for {new_patient.email}: {mail_result}")

    # Send SMS with login instructions if phone number exists
    if new_patient.phone_number:
        sms_message = (
            f"Welcome to Hospitease!\n"
            f"Login to your portal: http://localhost:3000/patient/login\n"
            f"Use Patient ID: {new_patient.patient_unique_id}\n"
            f"Password: your date of birth in MM/DD/YYYY format."
        )
        sms_result = send_sms(
            to_number=new_patient.phone_number,
            body=sms_message
        )
        logging.info(f"Twilio SMS result for {new_patient.phone_number}: {sms_result}")

    return PatientResponse.model_validate(new_patient)

async def update_patient(db: AsyncSession, patient_id: int, patient_data: PatientUpdate):
    result = await db.execute(select(Patient).filter(Patient.id == patient_id))
    patient = result.scalars().first()
    if not patient:
        return None

    for key, value in patient_data.model_dump(exclude_unset=True).items():
        setattr(patient, key, value)

    await db.commit()
    await db.refresh(patient)
    return PatientResponse.model_validate(patient)

async def delete_patient(db: AsyncSession, patient_id: int):
    result = await db.execute(select(Patient).filter(Patient.id == patient_id))
    patient = result.scalars().first()
    if not patient:
        return None

    await db.delete(patient)
    await db.commit()
    return {"message": "Patient deleted successfully"}

async def search_patients(db: AsyncSession, search_criteria: dict):
    query = select(Patient)
    for field, value in search_criteria.items():
        if hasattr(Patient, field):
            if isinstance(value, int):
                query = query.filter(getattr(Patient, field) == value)
            else:
                query = query.filter(getattr(Patient, field).ilike(f"%{value}%"))

    result = await db.execute(query)
    patients = result.scalars().all()
    return [PatientResponse.model_validate(patient) for patient in patients]

async def get_hospital_by_patient_id(db: AsyncSession, patient_id: int):
    result = await db.execute(
        select(Patient).filter(Patient.id == patient_id)
    )
    patient = result.scalars().first()
    if not patient or not patient.hospital_id:
        return None

    result = await db.execute(
        select(Hospital)
        .options(
            selectinload(Hospital.permissions),
            selectinload(Hospital.hospital_payments)
        )
        .filter(Hospital.id == patient.hospital_id)
    )
    hospital = result.scalars().first()
    return hospital

def calculate_age(date_of_birth: str) -> int:
    if not date_of_birth:
        return None
    try:
        dob = datetime.strptime(date_of_birth, "%Y-%m-%d")
        today = datetime.today()
        return today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    except ValueError:
        return None

async def get_patients_by_hospital_id(db: AsyncSession, hospital_id: int) -> List[dict]:
    result = await db.execute(
        select(Patient).filter(Patient.hospital_id == hospital_id)
    )
    patients = result.scalars().all()

    response = []
    for patient in patients:
        full_name = " ".join(filter(None, [patient.first_name, patient.middle_name, patient.last_name]))
        response.append({
            "id": patient.id,
            "uniqueId": patient.patient_unique_id,
            "name": full_name,
            "phone": patient.phone_number,
            "age": calculate_age(patient.date_of_birth),
            "gender": patient.gender
        })

    return response

async def login_patient_by_mrd(db: AsyncSession, mrd_number: int, password: str):
    print(f"Login attempt: mrd_number={mrd_number}, password={password}")  # Log incoming params
    result = await db.execute(select(Patient).filter(Patient.patient_unique_id == str(mrd_number)))
    patient = result.scalars().first()
    print(f"DB patient: {patient}")  # Log patient object
    if not patient or not patient.date_of_birth:
        print("No patient found or missing date_of_birth")
        return None
    try:
        dob = datetime.strptime(patient.date_of_birth, "%Y-%m-%d")
    except ValueError:
        print(f"Invalid date_of_birth format in DB: {patient.date_of_birth}")
        return None
    dob_str = dob.strftime("%d/%m/%Y")
    dob_str_noslash = dob.strftime("%d%m%Y")
    print(f"DB DOB for password check: {dob_str} or {dob_str_noslash}")
    if password != dob_str and password != dob_str_noslash:
        print("Password does not match DOB")
        return None
    print("Login successful")
    return PatientResponse.model_validate(patient)

async def get_patients_by_doctor_id(db: AsyncSession, doctor_id: int):
    result = await db.execute(
        select(Patient)
        .join(Appointment, Patient.id == Appointment.patient_id)
        .where(Appointment.doctor_id == doctor_id)
        .options(selectinload(Patient.appointments))
        .distinct()
    )
    return result.scalars().all()

async def summarize_patient_history(db: AsyncSession, patient_id: int):
    from app.models.appointment import Appointment
    from app.models.test import Test
    from app.models.appointment_medicine import Medicine
    from app.models.vital import Vital
    from app.models.symtom import Symptom
    from app.models.health_info import HealthInfo

    all_appts_result = await db.execute(
        select(Appointment)
        .filter(Appointment.patient_id == patient_id)
        .order_by(Appointment.appointment_date, Appointment.appointment_time)
    )
    all_appointments = all_appts_result.scalars().all()

    if not all_appointments:
        return None

    visit_history = []
    for appt in all_appointments:
        tests_result = await db.execute(
            select(Test).filter(Test.appointment_id == appt.id)
        )
        tests = [t.__dict__ for t in tests_result.scalars().all()]

        medicines_result = await db.execute(
            select(Medicine).filter(Medicine.appointment_id == appt.id)
        )
        medicines = [m.__dict__ for m in medicines_result.scalars().all()]

        vitals_result = await db.execute(
            select(Vital).filter(Vital.appointment_id == appt.id)
        )
        vitals = [v.__dict__ for v in vitals_result.scalars().all()]

        symptoms_result = await db.execute(
            select(Symptom).filter(Symptom.appointment_id == appt.id)
        )
        symptoms = [s.__dict__ for s in symptoms_result.scalars().all()]

        health_info_result = await db.execute(
            select(HealthInfo).filter(HealthInfo.appointment_id == appt.id)
        )
        health_info = health_info_result.scalars().first()
        health_info_data = health_info.__dict__ if health_info else {}

        visit_data = {
            "appointment": {
                "id": appt.id,
                "appointment_datetime": appt.appointment_datetime,
                "problem": appt.problem,
                "appointment_type": appt.appointment_type,
                "reason": appt.reason,
                "status": appt.status,
                "blood_pressure": appt.blood_pressure,
                "pulse_rate": appt.pulse_rate,
                "temperature": appt.temperature,
                "spo2": appt.spo2,
                "weight": appt.weight,
                "additional_notes": appt.additional_notes,
                "advice": appt.advice,
                "follow_up_date": appt.follow_up_date,
                "follow_up_notes": appt.follow_up_notes,
                "appointment_date": appt.appointment_date,
                "appointment_time": appt.appointment_time,
                "mode_of_appointment": appt.mode_of_appointment,
            },
            "tests": tests,
            "medicines": medicines,
            "vitals": vitals,
            "symptoms": symptoms,
            "health_info": health_info_data,
        }
        visit_history.append(visit_data)

    prompt = (
        "You are a helpful assistant. Please summarize the patient's health progress in simple language, so the patient can easily understand. "
        "Focus on changes in blood pressure, pulse rate, temperature, SpO2, and weight. "
        "Mention if things are improving, getting worse, or staying the same. "
        "Do not use medical jargon. Use short, clear sentences. "
        "Here is the patient's visit history:\n"
        f"{visit_history}\n"
        "Give a friendly summary and any advice for the patient."
    )

    chat = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3
    )

    summary = chat.choices[0].message.content
    return summary