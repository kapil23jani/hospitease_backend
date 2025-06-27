from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from app.models.bed_type import BedType
from app.schemas.bed_type import BedTypeCreate, BedTypeUpdate

async def create_bed_type(db: AsyncSession, bed_type: BedTypeCreate):
    db_bed_type = BedType(**bed_type.dict())
    db.add(db_bed_type)
    await db.commit()
    await db.refresh(db_bed_type)
    return db_bed_type

async def get_bed_type(db: AsyncSession, bed_type_id: int):
    result = await db.execute(select(BedType).where(BedType.id == bed_type_id))
    return result.scalar_one_or_none()

async def get_all_bed_types(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(BedType).offset(skip).limit(limit))
    return result.scalars().all()

async def update_bed_type(db: AsyncSession, bed_type_id: int, bed_type: BedTypeUpdate):
    await db.execute(
        update(BedType).where(BedType.id == bed_type_id).values(**bed_type.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_bed_type(db, bed_type_id)

async def delete_bed_type(db: AsyncSession, bed_type_id: int):
    await db.execute(delete(BedType).where(BedType.id == bed_type_id))
    await db.commit()