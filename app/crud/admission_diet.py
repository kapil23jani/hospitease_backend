from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from app.models.admission_diet import AdmissionDiet
from app.schemas.admission_diet import AdmissionDietCreate, AdmissionDietUpdate

async def create_admission_diet(db: AsyncSession, diet: AdmissionDietCreate):
    db_diet = AdmissionDiet(**diet.dict())
    db.add(db_diet)
    await db.commit()
    await db.refresh(db_diet)
    return db_diet

async def get_admission_diet(db: AsyncSession, diet_id: int):
    result = await db.execute(select(AdmissionDiet).where(AdmissionDiet.id == diet_id))
    return result.scalar_one_or_none()

async def get_all_admission_diets(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(AdmissionDiet).offset(skip).limit(limit))
    return result.scalars().all()

async def update_admission_diet(db: AsyncSession, diet_id: int, diet: AdmissionDietUpdate):
    await db.execute(
        update(AdmissionDiet).where(AdmissionDiet.id == diet_id).values(**diet.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_admission_diet(db, diet_id)

async def delete_admission_diet(db: AsyncSession, diet_id: int):
    await db.execute(delete(AdmissionDiet).where(AdmissionDiet.id == diet_id))
    await db.commit()

async def get_diets_by_admission_id(db: AsyncSession, admission_id: int, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(AdmissionDiet).where(AdmissionDiet.admission_id == admission_id).offset(skip).limit(limit)
    )
    return result.scalars().all()