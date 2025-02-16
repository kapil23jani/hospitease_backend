from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.hospital import Hospital
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from app.schemas.hospital import HospitalCreate, HospitalResponse, HospitalUpdate

async def create_hospital(db: AsyncSession, hospital: HospitalCreate):
    try:
        new_hospital = Hospital(
            name=hospital.name,
            address=hospital.address,
            city=hospital.city,
            state=hospital.state,
            country=hospital.country,
            phone_number=hospital.phone_number,
            email=hospital.email
        )
        db.add(new_hospital)
        await db.commit()
        await db.refresh(new_hospital)
        return new_hospital
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=f"Integrity Error: {str(e)}")


async def get_hospital(db: AsyncSession, hospital_id: int):
    result = await db.execute(select(Hospital).filter(Hospital.id == hospital_id))
    return result.scalars().first()

async def get_hospitals(db: AsyncSession, skip: int = 0, limit: int = 10):
    result = await db.execute(select(Hospital).offset(skip).limit(limit))
    return result.scalars().all()

async def update_hospital(db: AsyncSession, hospital_id: int, hospital_update: HospitalUpdate):
    db_hospital = await get_hospital(db, hospital_id)
    if db_hospital:
        for key, value in hospital_update.dict(exclude_unset=True).items():
            setattr(db_hospital, key, value)
        await db.commit()
        await db.refresh(db_hospital)
    return db_hospital

async def delete_hospital(db: AsyncSession, hospital_id: int):
    db_hospital = await get_hospital(db, hospital_id)
    if db_hospital:
        await db.delete(db_hospital)
        await db.commit()
    return db_hospital
