from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from app.models.ward import Ward
from app.schemas.ward import WardCreate, WardUpdate

async def create_ward(db: AsyncSession, ward: WardCreate):
    db_ward = Ward(**ward.dict())
    db.add(db_ward)
    await db.commit()
    await db.refresh(db_ward)
    return db_ward

async def get_ward(db: AsyncSession, ward_id: int):
    result = await db.execute(select(Ward).where(Ward.id == ward_id))
    return result.scalar_one_or_none()

async def get_all_wards(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(Ward).offset(skip).limit(limit))
    return result.scalars().all()

async def update_ward(db: AsyncSession, ward_id: int, ward: WardUpdate):
    await db.execute(
        update(Ward).where(Ward.id == ward_id).values(**ward.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_ward(db, ward_id)

async def delete_ward(db: AsyncSession, ward_id: int):
    await db.execute(delete(Ward).where(Ward.id == ward_id))
    await db.commit()

async def get_wards_by_hospital_id(db: AsyncSession, hospital_id: int, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(Ward).where(Ward.hospital_id == hospital_id).offset(skip).limit(limit)
    )
    return result.scalars().all()