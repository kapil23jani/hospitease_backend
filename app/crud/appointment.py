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

async def create_appointment(db: AsyncSession, appointment: AppointmentCreate):
    appointment_datetime = appointment.appointment_datetime.replace(tzinfo=None)

    db_appointment = Appointment(
        patient_id=appointment.patient_id,
        doctor_id=appointment.doctor_id,
        appointment_datetime=appointment_datetime,
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
            appointment_datetime=appt.appointment_datetime,
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

    if "appointment_datetime" in update_data:
        update_data["appointment_datetime"] = update_data["appointment_datetime"].replace(tzinfo=None)

    if "follow_up_date" in update_data:
        update_data["follow_up_date"] = update_data["follow_up_date"].replace(tzinfo=None)

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
    now = datetime.utcnow()
    today_start = datetime(now.year, now.month, now.day)
    today_end = today_start + timedelta(days=1)
    next_2_days = today_end + timedelta(days=2)
    prev_2_days = today_start - timedelta(days=2)

    result = await db.execute(
        select(Appointment)
        .options(
            selectinload(Appointment.patient),
            selectinload(Appointment.doctor)
        )
        .filter(Appointment.appointment_datetime >= prev_2_days)
        .filter(Appointment.appointment_datetime < next_2_days)
    )
    appointments = result.scalars().all()

    today, upcoming, past = [], [], []

    for appt in appointments:
        appt_time = appt.appointment_datetime
        if appt_time.tzinfo is not None:
            appt_time = appt_time.replace(tzinfo=None)

        response_data = AppointmentListingResponse(
            id=appt.id,
            patient=PatientResponse.from_orm(appt.patient),
            doctor=DoctorResponse.from_orm(appt.doctor),
            appointment_datetime=appt.appointment_datetime,
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
        )

        if today_start <= appt_time < today_end:
            today.append(response_data)
        elif today_end <= appt_time < next_2_days:
            upcoming.append(response_data)
        elif prev_2_days <= appt_time < today_start:
            past.append(response_data)

    today.sort(key=lambda x: x.appointment_datetime)
    upcoming.sort(key=lambda x: x.appointment_datetime)
    past.sort(key=lambda x: x.appointment_datetime)

    return {
        "today": today,
        "upcoming": upcoming,
        "past": past,
    }

from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import joinedload
from app.schemas.appointment import AppointmentListingResponse, DoctorResponse, PatientResponse
from app.models.appointment import Appointment

async def get_appointments_by_date_range(
    db: AsyncSession, start_date: str, end_date: str, skip: int = 0, limit: int = 100
):
    try:
        # Ensure the dates are in the correct format
        try:
            start_datetime = datetime.strptime(start_date, "%Y-%m-%d")
            end_datetime = datetime.strptime(end_date, "%Y-%m-%d")
        except ValueError as e:
            return {"error": f"Invalid date format. Please use YYYY-MM-DD. Details: {str(e)}"}

        # Adjust the end date to the last moment of the day (23:59:59.999999)
        end_datetime = end_datetime.replace(hour=23, minute=59, second=59, microsecond=999999)

        # Execute the query to get appointments in the given range
        result = await db.execute(
            select(Appointment)
            .options(joinedload(Appointment.patient), joinedload(Appointment.doctor))
            .filter(Appointment.appointment_datetime >= start_datetime)
            .filter(Appointment.appointment_datetime <= end_datetime)
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
                appointment_datetime=appt.appointment_datetime,
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
            ))

        return response
    except Exception as e:
        # Handle any unexpected exceptions
        return {"error": f"An unexpected error occurred: {str(e)}"}
