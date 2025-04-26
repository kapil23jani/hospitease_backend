from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException

from app.models.hospital import Hospital
from app.models.user import User
from app.schemas.hospital import HospitalCreate, HospitalUpdate


async def create_hospital(db: AsyncSession, hospital: HospitalCreate):
    try:
        if hospital.admin_id:
            admin = await db.execute(select(User).filter(User.id == hospital.admin_id))
            admin_user = admin.scalars().first()
            if not admin_user:
                raise HTTPException(status_code=404, detail="Admin user not found")

        new_hospital = Hospital(
            name=hospital.name,
            registration_number=hospital.registration_number,
            type=hospital.type,
            logo_url=hospital.logo_url,
            website=hospital.website,
            admin_id=hospital.admin_id,
            owner_name=hospital.owner_name,
            admin_contact_number=hospital.admin_contact_number,
            number_of_beds=hospital.number_of_beds,
            departments=hospital.departments,
            specialties=hospital.specialties,
            facilities=hospital.facilities,
            ambulance_services=hospital.ambulance_services,
            opening_hours=hospital.opening_hours,
            license_number=hospital.license_number,
            license_expiry_date=hospital.license_expiry_date,
            is_accredited=hospital.is_accredited,
            external_id=hospital.external_id,
            timezone=hospital.timezone,
            is_active=hospital.is_active,
        )
        db.add(new_hospital)
        await db.commit()
        await db.refresh(new_hospital)
        return new_hospital
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=f"Integrity Error: {str(e)}")


async def get_hospital(db: AsyncSession, hospital_id: int):
    stmt = select(Hospital).options(selectinload(Hospital.admin)).filter(Hospital.id == hospital_id)
    result = await db.execute(stmt)
    hospital = result.scalars().first()
    if not hospital:
        raise HTTPException(status_code=404, detail="Hospital not found")
    return hospital


async def get_hospitals(db: AsyncSession, skip: int = 0, limit: int = 100):
    stmt = (
        select(Hospital)
        .options(selectinload(Hospital.admin))
        .offset(skip)
        .limit(limit)
    )
    result = await db.execute(stmt)
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
