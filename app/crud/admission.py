from typing import Optional
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

async def get_admissions_filtered(
    db: AsyncSession,
    doctor_id: Optional[int] = None,
    staff_id: Optional[int] = None,
    patient_id: Optional[int] = None
):
    query = select(Admission).options(
        selectinload(Admission.hospital),
        selectinload(Admission.vitals),
        selectinload(Admission.medicines),
        selectinload(Admission.nursing_notes),
        selectinload(Admission.tests),
        selectinload(Admission.diets),
        selectinload(Admission.discharge),
    )
    if doctor_id is not None:
        query = query.where(Admission.doctor_id == doctor_id)
    if staff_id is not None:
        query = query.where(Admission.staff_id == staff_id)
    if patient_id is not None:
        query = query.where(Admission.patient_id == patient_id)
    result = await db.execute(query)
    return result.scalars().all()

async def get_admissions_by_hospital_id(db: AsyncSession, hospital_id: int):
    result = await db.execute(
        select(Admission)
        .options(
            selectinload(Admission.hospital),
            selectinload(Admission.vitals),
            selectinload(Admission.medicines),
            selectinload(Admission.nursing_notes),
            selectinload(Admission.tests),
            selectinload(Admission.diets),
            selectinload(Admission.discharge),
        )
        .where(Admission.hospital_id == hospital_id)
    )
    return result.scalars().all()

async def get_admissions_by_doctor_id(db: AsyncSession, doctor_id: int):
    result = await db.execute(
        select(Admission)
        .options(
            selectinload(Admission.hospital),
            selectinload(Admission.vitals),
            selectinload(Admission.medicines),
            selectinload(Admission.nursing_notes),
            selectinload(Admission.tests),
            selectinload(Admission.diets),
            selectinload(Admission.discharge),
        )
        .where(Admission.doctor_id == doctor_id)
    )
    return result.scalars().all()

async def get_admissions_by_staff_id(db: AsyncSession, staff_id: int):
    result = await db.execute(
        select(Admission)
        .options(
            selectinload(Admission.hospital),
            selectinload(Admission.vitals),
            selectinload(Admission.medicines),
            selectinload(Admission.nursing_notes),
            selectinload(Admission.tests),
            selectinload(Admission.diets),
            selectinload(Admission.discharge),
        )
        .where(Admission.staff_id == staff_id)
    )
    return result.scalars().all()

async def get_admissions_by_patient_id(db: AsyncSession, patient_id: int):
    result = await db.execute(
        select(Admission)
        .options(
            selectinload(Admission.hospital),
            selectinload(Admission.vitals),
            selectinload(Admission.medicines),
            selectinload(Admission.nursing_notes),
            selectinload(Admission.tests),
            selectinload(Admission.diets),
            selectinload(Admission.discharge),
        )
        .where(Admission.patient_id == patient_id)
    )
    return result.scalars().all()