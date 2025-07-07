from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.medical_history import MedicalHistory
from app.schemas.medical_history import MedicalHistoryCreate, MedicalHistoryUpdate

async def create_medical_history(db: AsyncSession, mh: MedicalHistoryCreate):
    db_mh = MedicalHistory(**mh.dict())
    db.add(db_mh)
    await db.commit()
    await db.refresh(db_mh)
    return db_mh

async def get_medical_histories_by_patient(db: AsyncSession, patient_id: int):
    result = await db.execute(select(MedicalHistory).where(MedicalHistory.patient_id == patient_id))
    return result.scalars().all()

async def get_medical_history(db: AsyncSession, mh_id: int):
    result = await db.execute(select(MedicalHistory).where(MedicalHistory.id == mh_id))
    return result.scalar_one_or_none()

async def update_medical_history(db: AsyncSession, mh_id: int, mh_update: MedicalHistoryUpdate):
    mh = await get_medical_history(db, mh_id)
    if not mh:
        return None
    for key, value in mh_update.dict(exclude_unset=True).items():
        setattr(mh, key, value)
    db.add(mh)
    await db.commit()
    await db.refresh(mh)
    return mh

async def delete_medical_history(db: AsyncSession, mh_id: int):
    mh = await get_medical_history(db, mh_id)
    if mh:
        await db.delete(mh)
        await db.commit()
    return mh
