from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from app.models.symtom import Symptom
from app.schemas.symtom import SymptomCreate, SymptomUpdate
from app.models import Appointment

async def create_symptom(db: AsyncSession, symptom: SymptomCreate):
    new_symptom = Symptom(
        description=symptom.description,
        duration=symptom.duration,
        severity=symptom.severity,
        onset=symptom.onset,
        contributing_factors=symptom.contributing_factors,
        recurring=symptom.recurring,
        doctor_comment=symptom.doctor_comment,
        doctor_suggestions=symptom.doctor_suggestions,
        appointment_id=symptom.appointment_id
    )
    db.add(new_symptom)
    await db.commit()
    await db.refresh(new_symptom)
    return new_symptom

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
from app.models import Symptom

async def get_symptoms_by_appointment_id(
    db: AsyncSession, 
    appointment_id: int, 
    skip: int = 0, 
    limit: int = 10
) -> List[Symptom]:
    """Fetch symptoms for a given appointment ID."""
    query = select(Symptom).where(Symptom.appointment_id == appointment_id).offset(skip).limit(limit)
    result = await db.execute(query)
    symptoms = result.scalars().all()

    for symptom in symptoms:
        symptom.onset = symptom.onset or "Unknown"

    return symptoms

async def get_symptom_by_id(db: AsyncSession, symptom_id: int) -> Optional[Symptom]:
    """Fetch a single symptom by its ID."""
    query = select(Symptom).where(Symptom.id == symptom_id)
    result = await db.execute(query)
    return result.scalars().first()


async def update_symptom(db: AsyncSession, symptom_id: int, symptom_data: SymptomUpdate):
    query = select(Symptom).where(Symptom.id == symptom_id)
    result = await db.execute(query)
    db_symptom = result.scalars().first()

    if not db_symptom:
        return None

    for key, value in symptom_data.dict(exclude_unset=True).items():
        setattr(db_symptom, key, value)

    db.add(db_symptom)
    await db.commit()
    await db.refresh(db_symptom)
    
    return db_symptom


async def delete_symptom(db: AsyncSession, symptom_id: int):
    query = select(Symptom).where(Symptom.id == symptom_id)
    result = await db.execute(query)
    db_symptom = result.scalars().first()

    if not db_symptom:
        return None

    await db.delete(db_symptom)
    await db.commit()
    return db_symptom

async def get_all_symptoms_by_patient_id(
    db: AsyncSession,
    patient_id: int,
    skip: int = 0,
    limit: int = 100
) -> List[Symptom]:
    stmt = (
        select(Symptom)
        .join(Appointment)
        .where(Appointment.patient_id == patient_id)
        .offset(skip)
        .limit(limit)
    )
    result = await db.execute(stmt)
    return result.scalars().all()