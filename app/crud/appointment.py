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

async def create_appointment(db: AsyncSession, appointment: AppointmentCreate):

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
    )
    db.add(db_appointment)
    await db.commit()
    await db.refresh(db_appointment)

    return db_appointment

async def get_appointments(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(Appointment)
        .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
        .offset(skip)
        .limit(limit)
    )
    return result.scalars().all()

async def get_listing_appointments(db: AsyncSession, skip: int = 0, limit: int = 100) -> List[AppointmentListingResponse]:
    result = await db.execute(
        select(Appointment)
        .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
        .offset(skip)
        .limit(limit)
    )
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
            status=appt.status
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

async def get_grouped_appointments(db: AsyncSession):
    # Current time and date
    now = datetime.utcnow()
    today_start = datetime(now.year, now.month, now.day)
    today_end = today_start + timedelta(days=1)
    next_2_days = today_end + timedelta(days=2)
    prev_2_days = today_start - timedelta(days=2)

    prev_2_days_str = prev_2_days.strftime("%Y-%m-%d")
    next_2_days_str = next_2_days.strftime("%Y-%m-%d")
    today_start_str = today_start.strftime("%Y-%m-%d")
    today_end_str = today_end.strftime("%Y-%m-%d")

    result = await db.execute(
        select(Appointment)
        .options(
            selectinload(Appointment.patient),
            selectinload(Appointment.doctor)
        )
        .filter(Appointment.appointment_date >= prev_2_days_str)
        .filter(Appointment.appointment_date < next_2_days_str)
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
            status=appt.status
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



