from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List, Optional
from app.models.appointment_medicine import Medicine
from app.models.patient import Patient
from app.models.appointment import Appointment
from app.schemas.appointment_medicine import MedicineCreate, MedicineUpdate

async def create_medicine(db: AsyncSession, medicine: MedicineCreate):
    new_medicine = Medicine(**medicine.dict())
    db.add(new_medicine)
    await db.commit()
    await db.refresh(new_medicine)
    return new_medicine

async def get_medicines_by_appointment_id(db: AsyncSession, appointment_id: int, skip: int = 0, limit: int = 10) -> List[Medicine]:
    query = select(Medicine).where(Medicine.appointment_id == appointment_id).offset(skip).limit(limit)
    result = await db.execute(query)
    return result.scalars().all()

async def get_medicine_by_id(db: AsyncSession, medicine_id: int) -> Optional[Medicine]:
    query = select(Medicine).where(Medicine.id == medicine_id)
    result = await db.execute(query)
    return result.scalars().first()

async def update_medicine(db: AsyncSession, medicine_id: int, medicine_data: MedicineUpdate):
    query = select(Medicine).where(Medicine.id == medicine_id)
    result = await db.execute(query)
    db_medicine = result.scalars().first()

    if not db_medicine:
        return None

    for key, value in medicine_data.dict(exclude_unset=True).items():
        setattr(db_medicine, key, value)

    db.add(db_medicine)
    await db.commit()
    await db.refresh(db_medicine)
    
    return db_medicine

async def delete_medicine(db: AsyncSession, medicine_id: int):
    query = select(Medicine).where(Medicine.id == medicine_id)
    result = await db.execute(query)
    db_medicine = result.scalars().first()

    if not db_medicine:
        return None

    await db.delete(db_medicine)
    await db.commit()
    return db_medicine

async def get_all_medicines_by_patient_id(db: AsyncSession, patient_id: int, skip: int = 0, limit: int = 100) -> List[Medicine]:
    stmt = (
        select(Medicine)
        .join(Appointment)
        .where(Appointment.patient_id == patient_id)
        .offset(skip)
        .limit(limit)
    )
    result = await db.execute(stmt)
    return result.scalars().all()
