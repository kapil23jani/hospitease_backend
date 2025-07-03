from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from app.models.admission_vital import AdmissionVital
from app.schemas.admission_vital import AdmissionVitalCreate, AdmissionVitalUpdate

async def create_admission_vital(db: AsyncSession, vital: AdmissionVitalCreate):
    db_vital = AdmissionVital(**vital.dict())
    db.add(db_vital)
    await db.commit()
    await db.refresh(db_vital)
    return db_vital

async def get_admission_vital(db: AsyncSession, vital_id: int):
    result = await db.execute(select(AdmissionVital).where(AdmissionVital.id == vital_id))
    return result.scalar_one_or_none()

async def get_all_admission_vitals(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(AdmissionVital).offset(skip).limit(limit))
    return result.scalars().all()

async def update_admission_vital(db: AsyncSession, vital_id: int, vital: AdmissionVitalUpdate):
    await db.execute(
        update(AdmissionVital).where(AdmissionVital.id == vital_id).values(**vital.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_admission_vital(db, vital_id)

async def delete_admission_vital(db: AsyncSession, vital_id: int):
    await db.execute(delete(AdmissionVital).where(AdmissionVital.id == vital_id))
    await db.commit()

async def get_vitals_by_admission_id(db: AsyncSession, admission_id: int, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(AdmissionVital).where(AdmissionVital.admission_id == admission_id).offset(skip).limit(limit)
    )
    return result.scalars().all()