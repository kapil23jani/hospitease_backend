from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.hospital import Hospital
from app.schemas.hospital import HospitalCreate

async def create_hospital(db: AsyncSession, hospital_data: HospitalCreate):
    new_hospital = Hospital(**hospital_data.dict())
    db.add(new_hospital)
    await db.commit()
    await db.refresh(new_hospital)
    return new_hospital

async def get_hospital(db: AsyncSession, hospital_id: int):
    result = await db.execute(select(Hospital).where(Hospital.id == hospital_id))
    return result.scalars().first()

async def get_all_hospitals(db: AsyncSession, skip: int = 0, limit: int = 10):
    result = await db.execute(select(Hospital).offset(skip).limit(limit))
    return result.scalars().all()

async def update_hospital(db: AsyncSession, hospital_id: int, hospital_data: HospitalCreate):
    hospital = await get_hospital(db, hospital_id)
    if not hospital:
        return None
    for key, value in hospital_data.dict().items():
        setattr(hospital, key, value)
    db.add(hospital)
    await db.commit()
    await db.refresh(hospital)
    return hospital

async def delete_hospital(db: AsyncSession, hospital_id: int):
    hospital = await get_hospital(db, hospital_id)
    if not hospital:
        return None
    await db.delete(hospital)
    await db.commit()
    return hospital

async def hospital_exists(db: AsyncSession, hospital_id: int):
    hospital = await get_hospital(db, hospital_id)
    return hospital is not None
