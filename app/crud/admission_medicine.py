from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from app.models.admission_medicine import AdmissionMedicine
from app.schemas.admission_medicine import AdmissionMedicineCreate, AdmissionMedicineUpdate

async def create_admission_medicine(db: AsyncSession, medicine: AdmissionMedicineCreate):
    db_medicine = AdmissionMedicine(**medicine.dict())
    db.add(db_medicine)
    await db.commit()
    await db.refresh(db_medicine)
    return db_medicine

async def get_admission_medicine(db: AsyncSession, medicine_id: int):
    result = await db.execute(select(AdmissionMedicine).where(AdmissionMedicine.id == medicine_id))
    return result.scalar_one_or_none()

async def get_all_admission_medicines(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(AdmissionMedicine).offset(skip).limit(limit))
    return result.scalars().all()

async def update_admission_medicine(db: AsyncSession, medicine_id: int, medicine: AdmissionMedicineUpdate):
    await db.execute(
        update(AdmissionMedicine).where(AdmissionMedicine.id == medicine_id).values(**medicine.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_admission_medicine(db, medicine_id)

async def delete_admission_medicine(db: AsyncSession, medicine_id: int):
    await db.execute(delete(AdmissionMedicine).where(AdmissionMedicine.id == medicine_id))
    await db.commit()

async def get_medicines_by_admission_id(db: AsyncSession, admission_id: int, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(AdmissionMedicine).where(AdmissionMedicine.admission_id == admission_id).offset(skip).limit(limit)
    )
    return result.scalars().all()