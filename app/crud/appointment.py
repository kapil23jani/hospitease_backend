from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import joinedload
from app.models.appointment import Appointment
from app.schemas.appointment import AppointmentCreate, AppointmentUpdate
from datetime import timedelta

async def create_appointment(db: AsyncSession, appointment: AppointmentCreate):
    appointment_datetime = appointment.appointment_datetime.replace(tzinfo=None)

    db_appointment = Appointment(
        patient_id=appointment.patient_id,
        doctor_id=appointment.doctor_id,
        appointment_datetime=appointment_datetime,
        problem=appointment.problem,
        appointment_type=appointment.appointment_type,
        reason=appointment.reason
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
