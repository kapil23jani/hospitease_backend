from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from sqlalchemy.orm import selectinload
from app.models.admission import Admission
from app.schemas.admission import AdmissionCreate, AdmissionUpdate

async def create_admission(db: AsyncSession, admission: AdmissionCreate):
    db_admission = Admission(**admission.dict())
    db.add(db_admission)
    await db.commit()
    await db.refresh(db_admission)
    return db_admission

async def get_admission(db: AsyncSession, admission_id: int):
    result = await db.execute(
        select(Admission)
        .options(
            selectinload(Admission.vitals),
            selectinload(Admission.medicines),
            selectinload(Admission.nursing_notes),
            selectinload(Admission.tests),
            selectinload(Admission.diets),
        )
        .where(Admission.id == admission_id)
    )
    return result.scalar_one_or_none()

async def get_all_admissions(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(Admission)
        .options(
            selectinload(Admission.vitals),
            selectinload(Admission.medicines),
            selectinload(Admission.nursing_notes),
            selectinload(Admission.tests),
            selectinload(Admission.diets),
        )
        .offset(skip)
        .limit(limit)
    )
    return result.scalars().all()

async def update_admission(db: AsyncSession, admission_id: int, admission: AdmissionUpdate):
    await db.execute(
        update(Admission).where(Admission.id == admission_id).values(**admission.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_admission(db, admission_id)

async def delete_admission(db: AsyncSession, admission_id: int):
    await db.execute(delete(Admission).where(Admission.id == admission_id))
    await db.commit()