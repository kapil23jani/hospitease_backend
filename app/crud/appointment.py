from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import joinedload
from app.models.appointment import Appointment
from app.schemas.appointment import AppointmentCreate, AppointmentUpdate
from app.schemas.appointment import AppointmentResponse, DoctorResponse, PatientResponse, AppointmentListingResponse
from datetime import timedelta
from app.models.doctor import Doctor
from app.models.patient import Patient
from typing import List
from datetime import datetime, timedelta, timezone
from typing import List
from sqlalchemy.orm import selectinload
from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import joinedload
from app.schemas.appointment import AppointmentListingResponse, DoctorResponse, PatientResponse
from app.models.appointment import Appointment
from sqlalchemy import cast, Date
from sqlalchemy import text
from sqlalchemy import and_, or_, select
import logging
import openai
import os
from fastapi import UploadFile
from dotenv import load_dotenv
from app.utils.sms import send_sms
from app.models.hospital import Hospital
from app.models.test import Test
from app.models.appointment_medicine import Medicine
from app.models.test import Test
from app.models.vital import Vital
from app.models.symtom  import Symptom
from app.models.health_info import HealthInfo

openai_api_key = os.getenv("OPENAI_API_KEY")
client = openai.OpenAI(api_key=openai_api_key)

async def create_appointment(db: AsyncSession, appointment: AppointmentCreate):
    today_str = datetime.utcnow().strftime("%Y%m%d")
    result = await db.execute(
        text("SELECT appointment_unique_id FROM appointments WHERE appointment_unique_id LIKE :prefix ORDER BY id DESC LIMIT 1"),
        {"prefix": f"APT-{today_str}-%"}
    )
    last_id = result.scalar()
    if last_id:
        last_seq = int(last_id.split("-")[-1])
        next_seq = last_seq + 1
    else:
        next_seq = 1
    appointment_unique_id = f"APT-{today_str}-{str(next_seq).zfill(3)}"

    db_appointment = Appointment(
        patient_id=appointment.patient_id,
        doctor_id=appointment.doctor_id,
        appointment_datetime=appointment.appointment_datetime,
        problem=appointment.problem,
        appointment_type=appointment.appointment_type,
        reason=appointment.reason,
        blood_pressure=appointment.blood_pressure,
        pulse_rate=appointment.pulse_rate,
        temperature=appointment.temperature,
        spo2=appointment.spo2,
        weight=appointment.weight,
        additional_notes=appointment.additional_notes,
        advice=appointment.advice,
        follow_up_date=appointment.follow_up_date,
        follow_up_notes=appointment.follow_up_notes,
        appointment_date=appointment.appointment_date,
        appointment_time=appointment.appointment_time,
        hospital_id=appointment.hospital_id,
        status=appointment.status,
        appointment_unique_id=appointment_unique_id,
        mode_of_appointment=appointment.mode_of_appointment
    )
    db.add(db_appointment)
    await db.commit()
    await db.refresh(db_appointment)

    patient = await db.execute(select(Patient).filter(Patient.id == db_appointment.patient_id))
    patient_obj = patient.scalars().first()
    if patient_obj:
        patient_obj.patient_summary = None
        await db.commit()
        await db.refresh(patient_obj)

    doctor = await db.execute(select(Doctor).filter(Doctor.id == db_appointment.doctor_id))
    doctor_obj = doctor.scalars().first()
    patient = await db.execute(select(Patient).filter(Patient.id == db_appointment.patient_id))
    patient_obj = patient.scalars().first()
    hospital_name = None
    if doctor_obj and hasattr(doctor_obj, "hospital_id"):
        hospital = await db.execute(select(Hospital).filter(Hospital.id == doctor_obj.hospital_id))
        hospital_obj = hospital.scalars().first()
        hospital_name = hospital_obj.name if hospital_obj else "Unknown Hospital"

    # Prepare message
    appointment_msg = (
        f"Appointment Confirmed!\n"
        f"Doctor: Dr. {doctor_obj.first_name} {doctor_obj.last_name if doctor_obj else ''}\n"
        f"Hospital: {hospital_name}\n"
        f"Date: {db_appointment.appointment_date}\n"
        f"Time: {db_appointment.appointment_time}\n"
        f"Type: {db_appointment.appointment_type}\n"
        f"Reason: {db_appointment.reason}\n"
        f"Problem: {db_appointment.problem}\n"
        f"Appointment ID: {db_appointment.appointment_unique_id}\n"
        f"Status: {db_appointment.status}\n"
        f"Login: http://localhost:3000/patient/login\n"
        f"Use Patient ID: {patient_obj.patient_unique_id if patient_obj else ''}\n"
        f"Password: your date of birth in MM/DD/YYYY format."
    )

    # Send SMS if patient phone exists
    if patient_obj and patient_obj.phone_number:
        sms_result = send_sms(
            to_number=patient_obj.phone_number,
            body=appointment_msg
        )
        logging.info(f"Appointment SMS result for {patient_obj.phone_number}: {sms_result}")

    # Send email if patient email exists
    if patient_obj and patient_obj.email:
        mail_result = send_mail(
            to_email=patient_obj.email,
            subject="Your Appointment is Confirmed!",
            html_content=f"<pre>{appointment_msg}</pre>"
        )
        logging.info(f"Appointment email result for {patient_obj.email}: {mail_result}")

    return db_appointment

async def get_appointments(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(Appointment)
        .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
        .offset(skip)
        .limit(limit)
    )
    return result.scalars().all()

async def get_listing_appointments(
    db: AsyncSession,
    skip: int = 0,
    limit: int = 100,
    dateRange: str = None,
    doctorId: str = None,
    status: str = None,
    search: str = None,
    appointmentType: str = None,
    problem: str = None
) -> List[AppointmentListingResponse]:
    logging.info(f"[get_listing_appointments] Params from frontend: skip={skip}, limit={limit}, dateRange={dateRange}, doctorId={doctorId}, status={status}, search={search}, appointmentType={appointmentType}, problem={problem}")

    filters = []

    if dateRange:
        filters.append(Appointment.appointment_date == dateRange)
    if doctorId:
        filters.append(Appointment.doctor_id == int(doctorId))
    if status:
        filters.append(Appointment.status == status)
    if appointmentType:
        filters.append(Appointment.appointment_type == appointmentType)
    if problem:
        filters.append(Appointment.problem.ilike(f"%{problem}%"))
    if search:
        filters.append(
            or_(
                Patient.first_name.ilike(f"%{search}%"),
                Patient.last_name.ilike(f"%{search}%"),
                Patient.patient_unique_id.ilike(f"%{search}%"),
                Doctor.first_name.ilike(f"%{search}%"),
                Doctor.last_name.ilike(f"%{search}%"),
            )
        )

    # Always join Patient and Doctor for flexible search/filtering
    query = (
        select(Appointment)
        .join(Patient, Appointment.patient_id == Patient.id)
        .join(Doctor, Appointment.doctor_id == Doctor.id)
        .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
        .filter(and_(*filters))
        .offset(skip)
        .limit(limit)
    )

    result = await db.execute(query)
    appointments = result.scalars().all()

    response = []
    for appt in appointments:
        doctor = DoctorResponse.from_orm(appt.doctor)
        patient = PatientResponse.from_orm(appt.patient)
        response.append(AppointmentListingResponse(
            id=appt.id,
            patient=patient,
            doctor=doctor,
            problem=appt.problem,
            appointment_type=appt.appointment_type,
            reason=appt.reason,
            blood_pressure=appt.blood_pressure,
            pulse_rate=appt.pulse_rate,
            temperature=appt.temperature,
            spo2=appt.spo2,
            weight=appt.weight,
            additional_notes=appt.additional_notes,
            advice=appt.advice,
            follow_up_date=appt.follow_up_date,
            follow_up_notes=appt.follow_up_notes,
            updated_at=appt.updated_at,
            appointment_date=appt.appointment_date,
            appointment_time=appt.appointment_time,
            hospital_id=appt.hospital_id,
            status=appt.status,
            appointment_unique_id=appt.appointment_unique_id
        ))
    return response

async def get_appointment_by_id(db: AsyncSession, appointment_id: int):
    result = await db.execute(
        select(Appointment)
        .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
        .filter(Appointment.id == appointment_id)
    )
    return result.scalars().first()

async def get_appointments_by_doctor_id(db: AsyncSession, doctor_id: int, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(Appointment)
        .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
        .filter(Appointment.doctor_id == doctor_id)
        .offset(skip)
        .limit(limit)
    )
    return result.scalars().all()

async def get_appointments_by_patient_id(db: AsyncSession, patient_id: int, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(Appointment)
        .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
        .filter(Appointment.patient_id == patient_id)
        .offset(skip)
        .limit(limit)
    )
    return result.scalars().all()

async def update_appointment(db: AsyncSession, appointment_id: int, appointment: AppointmentUpdate):
    result = await db.execute(select(Appointment).filter(Appointment.id == appointment_id))
    db_appointment = result.scalars().first()

    if not db_appointment:
        return None

    update_data = appointment.dict(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_appointment, key, value)

    await db.commit()
    await db.refresh(db_appointment)

    return db_appointment

async def delete_appointment(db: AsyncSession, appointment_id: int):
    result = await db.execute(select(Appointment).filter(Appointment.id == appointment_id))
    db_appointment = result.scalars().first()
    if db_appointment:
        await db.delete(db_appointment)
        await db.commit()
        return True
    return False

async def get_patient_by_appointment_id(db: AsyncSession, appointment_id: int):
    result = await db.execute(
        select(Appointment)
        .options(joinedload(Appointment.patient))
        .filter(Appointment.id == appointment_id)
    )
    appointment = result.scalars().first()
    return appointment.patient if appointment else None

async def get_doctor_by_appointment_id(db: AsyncSession, appointment_id: int):
    result = await db.execute(
        select(Appointment)
        .options(
            joinedload(Appointment.doctor).joinedload(Doctor.hospital)  # load hospital as well
        )
        .filter(Appointment.id == appointment_id)
    )
    appointment = result.scalars().first()
    return appointment.doctor if appointment else None

async def get_grouped_appointments(db: AsyncSession, doctor_id: int = None, patient_id: int = None):
    now = datetime.utcnow()
    today_start = datetime(now.year, now.month, now.day)
    today_end = today_start + timedelta(days=1)
    next_2_days = today_end + timedelta(days=2)
    prev_2_days = today_start - timedelta(days=2)

    prev_2_days_str = prev_2_days.strftime("%Y-%m-%d")
    next_2_days_str = next_2_days.strftime("%Y-%m-%d")
    today_start_str = today_start.strftime("%Y-%m-%d")
    today_end_str = today_end.strftime("%Y-%m-%d")

    filters = [
        Appointment.appointment_date >= prev_2_days_str,
        Appointment.appointment_date < next_2_days_str,
    ]
    if doctor_id is not None:
        filters.append(Appointment.doctor_id == doctor_id)
    if patient_id is not None:
        filters.append(Appointment.patient_id == patient_id)

    result = await db.execute(
        select(Appointment)
        .options(
            selectinload(Appointment.patient),
            selectinload(Appointment.doctor)
        )
        .filter(*filters)
    )
    appointments = result.scalars().all()

    today, upcoming, past = [], [], []

    for appt in appointments:
        response_data = AppointmentListingResponse(
            id=appt.id,
            patient=PatientResponse.from_orm(appt.patient),
            doctor=DoctorResponse.from_orm(appt.doctor),
            problem=appt.problem,
            appointment_type=appt.appointment_type,
            reason=appt.reason,
            blood_pressure=appt.blood_pressure,
            pulse_rate=appt.pulse_rate,
            temperature=appt.temperature,
            spo2=appt.spo2,
            weight=appt.weight,
            additional_notes=appt.additional_notes,
            advice=appt.advice,
            follow_up_date=appt.follow_up_date,
            follow_up_notes=appt.follow_up_notes,
            updated_at=appt.updated_at,
            appointment_date=appt.appointment_date,
            appointment_time=appt.appointment_time,
            hospital_id=appt.hospital_id,
            status=appt.status,
            appointment_unique_id=appt.appointment_unique_id
        )

        if today_start_str <= appt.appointment_date < today_end_str and appt.status == "pending":
            today.append(response_data)
        elif today_end_str <= appt.appointment_date < next_2_days_str and appt.status == "pending":
            upcoming.append(response_data)
        elif prev_2_days_str <= appt.appointment_date < today_start_str:
            past.append(response_data)

    today.sort(key=lambda x: x.appointment_date)
    upcoming.sort(key=lambda x: x.appointment_date)
    past.sort(key=lambda x: x.appointment_date)

    return {
        "today": today,
        "upcoming": upcoming,
        "past": past,
    }
async def get_appointments_by_date_range(
    db: AsyncSession, start_date: str, end_date: str, skip: int = 0, limit: int = 100
):
    try:
        try:
            start_date_obj = datetime.strptime(start_date, "%Y-%m-%d").date()
            end_date_obj = datetime.strptime(end_date, "%Y-%m-%d").date()
        except ValueError as e:
            return {"error": f"Invalid date format. Please use YYYY-MM-DD. Details: {str(e)}"}

        # Query filtering directly on date column
        result = await db.execute(
            select(Appointment)
            .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
            .filter(Appointment.appointment_date >= start_date_obj)
            .filter(Appointment.appointment_date <= end_date_obj)
            .offset(skip)
            .limit(limit)
        )
        appointments = result.scalars().all()

        if not appointments:
            return {"message": "No appointments found for the given date range."}

        # Prepare the response list
        response = []
        for appt in appointments:
            doctor = DoctorResponse.from_orm(appt.doctor)
            patient = PatientResponse.from_orm(appt.patient)

            response.append(AppointmentListingResponse(
                id=appt.id,
                patient=patient,
                doctor=doctor,
                problem=appt.problem,
                appointment_type=appt.appointment_type,
                reason=appt.reason,
                blood_pressure=appt.blood_pressure,
                pulse_rate=appt.pulse_rate,
                temperature=appt.temperature,
                spo2=appt.spo2,
                weight=appt.weight,
                additional_notes=appt.additional_notes,
                advice=appt.advice,
                follow_up_date=appt.follow_up_date,
                follow_up_notes=appt.follow_up_notes,
                updated_at=appt.updated_at,
                appointment_date=appt.appointment_date,
                appointment_time=appt.appointment_time,
                hospital_id=appt.hospital_id,
                status=appt.status
            ))

        return response
    except Exception as e:
        return {"error": f"An unexpected error occurred: {str(e)}"}

async def get_appointments_by_hospital_id(
    db: AsyncSession, hospital_id: int, start_date: str, end_date: str
):
    try:
        print(f"[DEBUG] Called get_appointments_by_hospital_id with hospital_id = {hospital_id}, start_date = {start_date}, end_date = {end_date}")

        # Convert the string date to datetime
        try:
            start_datetime = datetime.strptime(start_date, "%Y-%m-%d")
            end_datetime = datetime.strptime(end_date, "%Y-%m-%d")
        except ValueError as e:
            print(f"[ERROR] Invalid date format: {e}")
            raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD.")

        appt_result = await db.execute(
            select(Appointment)
            .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
            .filter(
                Appointment.hospital_id == hospital_id,
                cast(Appointment.appointment_date, Date) >= start_datetime.date(),
                cast(Appointment.appointment_date, Date) <= end_datetime.date(),
                Appointment.status != "cancelled"
            )
        )
        appointments = appt_result.scalars().all()
        print(f"[DEBUG] Fetched {len(appointments)} appointments from DB")

        if not appointments:
            print("[DEBUG] No appointments found, returning empty list")
            return []

        response = []
        for idx, appt in enumerate(appointments):
            print(f"[DEBUG] Processing appointment #{idx + 1}")
            print(f"    appt.id = {appt.id}")
            print(f"    appt.patient = {appt.patient.first_name if appt.patient else 'None'}")
            print(f"    appt.doctor = {appt.doctor.first_name if appt.doctor else 'None'}")
            print(f"    appt.appointment_date = {appt.appointment_date}")
            print(f"    appt.appointment_time = {appt.appointment_time}")

            response.append({
                "id": appt.id,
                "title": f"Patient: {appt.patient.first_name} {appt.patient.last_name}" if appt.patient else "Patient: Unknown",
                "appointment_date": appt.appointment_date,
                "appointment_time": appt.appointment_time,
                "appointment_type": appt.appointment_type,
                "doctor_id": appt.doctor_id,
                "patient_id": appt.patient_id,
                "appointment_datetime": f"{appt.appointment_date}T{appt.appointment_time}" if appt.appointment_date and appt.appointment_time else None,
                "doctor": f"Dr. {appt.doctor.first_name} {appt.doctor.last_name}" if appt.doctor else "Dr. Unknown",
                "status": appt.status,
            })

        print(f"[DEBUG] Returning {len(response)} appointments in response")
        return response

    except Exception as e:
        print(f"[ERROR] Unexpected error in get_appointments_by_hospital_id: {e}")
        return []

async def transcribe_and_parse_prescription(
    db: AsyncSession, appointment_id: int, audio: UploadFile, language: str = "en"
):
    temp_path = f"temp_{appointment_id}.mp3"
    with open(temp_path, "wb") as f:
        f.write(await audio.read())

    # Transcribe with Whisper (new API)
    with open(temp_path, "rb") as f:
        note = client.audio.transcriptions.create(
            model="whisper-1",
            file=f,
            response_format="text"
        )
    os.remove(temp_path)

    prompt = f"""You are a medical assistant. Convert the doctor's note into JSON.
Note: {note}
Respond in this language: {language}
JSON format:
{{
  "complaint": "...",
  "diagnosis": "...",
  "medicines": [
    {{
      "name": "...",
      "dosage": "...",
      "frequency": "...",
      "duration": "...",
      "start_date": "...",
      "status": "...",
      "time_interval": "...",
      "route": "...",
      "quantity": "...",
      "instruction": "..."
    }}
  ],
  "tests": [
    {{
      "name": "...",
      "instruction": "..."
    }}
  ]
}}
"""

    chat = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3
    )

    output = chat.choices[0].message.content
    try:
        return eval(output)
    except Exception:
        return {"raw": output}

async def ai_prescription_suggestion(symptoms_text: str, symptoms_audio: UploadFile, language: str = "en"):
    # If audio, transcribe first
    if symptoms_audio:
        temp_path = f"temp_symptoms.mp3"
        with open(temp_path, "wb") as f:
            f.write(await symptoms_audio.read())
        with open(temp_path, "rb") as f:
            symptoms_text = client.audio.transcriptions.create(
                model="whisper-1",
                file=f,
                response_format="text"
            )
        os.remove(temp_path)
        if hasattr(symptoms_text, "text"):
            symptoms_text = symptoms_text.text

    if not symptoms_text:
        return {"error": "No symptoms provided."}

    prompt = f"""You are an expert medical assistant. Based on the following symptoms, suggest medicines, dosage, and all details in structured JSON.
Symptoms: {symptoms_text}
Respond in this language: {language}
JSON format:
{{
  "complaint": "...",
  "diagnosis": "...",
  "medicines": [
    {{
      "name": "...",
      "dosage": "...",
      "frequency": "...",
      "duration": "...",
      "start_date": "...",
      "status": "...",
      "time_interval": "...",
      "route": "...",
      "quantity": "...",
      "instruction": "..."
    }}
  ],
  "tests": [
    {{
      "name": "...",
      "instruction": "..."
    }}
  ]
}}
"""

    chat = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3
    )

    output = chat.choices[0].message.content
    try:
        return eval(output)
    except Exception:
        return {"raw": output}

async def summarize_appointment_visit(db: AsyncSession, appointment_id: int):
    result = await db.execute(
        select(Appointment).filter(Appointment.id == appointment_id)
    )
    appointment = result.scalars().first()
    if not appointment:
        return None  
    tests_result = await db.execute(
        select(Test).filter(Test.appointment_id == appointment_id)
    )
    tests = [t.__dict__ for t in tests_result.scalars().all()]

    medicines_result = await db.execute(
        select(Medicine).filter(Medicine.appointment_id == appointment_id)
    )
    medicines = [m.__dict__ for m in medicines_result.scalars().all()]

    vitals_result = await db.execute(
        select(Vital).filter(Vital.appointment_id == appointment_id)
    )
    vitals = [v.__dict__ for v in vitals_result.scalars().all()]

    symptoms_result = await db.execute(
        select(Symptom).filter(Symptom.appointment_id == appointment_id)
    )
    symptoms = [s.__dict__ for s in symptoms_result.scalars().all()]

    health_info_result = await db.execute(
        select(HealthInfo).filter(HealthInfo.appointment_id == appointment_id)
    )
    health_info = health_info_result.scalars().first()
    health_info_data = health_info.__dict__ if health_info else {}

    visit_data = {
        "appointment": {
            "id": appointment.id,
            "appointment_datetime": appointment.appointment_datetime,
            "problem": appointment.problem,
            "appointment_type": appointment.appointment_type,
            "reason": appointment.reason,
            "status": appointment.status,
            "blood_pressure": appointment.blood_pressure,
            "pulse_rate": appointment.pulse_rate,
            "temperature": appointment.temperature,
            "spo2": appointment.spo2,
            "weight": appointment.weight,
            "additional_notes": appointment.additional_notes,
            "advice": appointment.advice,
            "follow_up_date": appointment.follow_up_date,
            "follow_up_notes": appointment.follow_up_notes,
            "appointment_date": appointment.appointment_date,
            "appointment_time": appointment.appointment_time,
            "mode_of_appointment": appointment.mode_of_appointment,
        },
        "tests": tests,
        "medicines": medicines,
        "vitals": vitals,
        "symptoms": symptoms,
        "health_info": health_info_data,
    }

    prompt = (
        "Summarize the patient's visit history from the following data in a clear, concise way for a doctor or patient. "
        "Here is the JSON data:\n"
        f"{visit_data}\n"
        "Summarize from the first visit to the latest, including tests, medicines, vitals, symptoms, health info, family histories, and any important changes."
    )

    chat = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3
    )

    summary = chat.choices[0].message.content
    return summary

async def summarize_patient_visit_history(db: AsyncSession, appointment_id: int):
    result = await db.execute(
        select(Appointment).filter(Appointment.id == appointment_id)
    )
    appointment = result.scalars().first()
    if not appointment:
        return None
    patient_id = appointment.patient_id

    all_appts_result = await db.execute(
        select(Appointment)
        .filter(Appointment.patient_id == patient_id)
        .order_by(Appointment.appointment_date, Appointment.appointment_time)
    )
    all_appointments = all_appts_result.scalars().all()

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
        "Analyze the following patient's visit history and summarize key trends, patterns, and changes over time. "
        "Focus on how the patient's vitals (blood pressure, pulse rate, temperature, SpO2, weight) have changed, "
        "and mention any significant increases, decreases, or stability. "
        "Do not list each appointment separately. Instead, provide an overall summary of the patient's health progression, "
        "highlighting any important findings or recommendations. "
        "Here is the JSON data:\n"
        f"{visit_history}\n"
        "Summarize the trends and give actionable insights for the doctor or patient."
    )

    chat = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3
    )

    summary = chat.choices[0].message.content
    return summary