from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from app.models.bed import Bed
from app.schemas.bed import BedCreate, BedUpdate

async def create_bed(db: AsyncSession, bed: BedCreate):
    db_bed = Bed(**bed.dict())
    db.add(db_bed)
    await db.commit()
    await db.refresh(db_bed)
    return db_bed

async def get_bed(db: AsyncSession, bed_id: int):
    result = await db.execute(select(Bed).where(Bed.id == bed_id))
    return result.scalar_one_or_none()

async def get_all_beds(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(Bed).offset(skip).limit(limit))
    return result.scalars().all()

async def update_bed(db: AsyncSession, bed_id: int, bed: BedUpdate):
    await db.execute(
        update(Bed).where(Bed.id == bed_id).values(**bed.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_bed(db, bed_id)

async def delete_bed(db: AsyncSession, bed_id: int):
    await db.execute(delete(Bed).where(Bed.id == bed_id))
    await db.commit()