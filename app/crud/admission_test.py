from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from app.models.admission_test import AdmissionTest
from app.schemas.admission_test import AdmissionTestCreate, AdmissionTestUpdate

async def create_admission_test(db: AsyncSession, test: AdmissionTestCreate):
    db_test = AdmissionTest(**test.dict())
    db.add(db_test)
    await db.commit()
    await db.refresh(db_test)
    return db_test

async def get_admission_test(db: AsyncSession, test_id: int):
    result = await db.execute(select(AdmissionTest).where(AdmissionTest.id == test_id))
    return result.scalar_one_or_none()

async def get_all_admission_tests(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(AdmissionTest).offset(skip).limit(limit))
    return result.scalars().all()

async def update_admission_test(db: AsyncSession, test_id: int, test: AdmissionTestUpdate):
    await db.execute(
        update(AdmissionTest).where(AdmissionTest.id == test_id).values(**test.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_admission_test(db, test_id)

async def delete_admission_test(db: AsyncSession, test_id: int):
    await db.execute(delete(AdmissionTest).where(AdmissionTest.id == test_id))
    await db.commit()

async def get_tests_by_admission_id(db: AsyncSession, admission_id: int, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(AdmissionTest).where(AdmissionTest.admission_id == admission_id).offset(skip).limit(limit)
    )
    return result.scalars().all()