from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload
from app.models.patient import Patient
from app.schemas.patient import PatientCreate, PatientUpdate, PatientResponse
import uuid
from sqlalchemy import text


async def get_patients(db: AsyncSession):
    result = await db.execute(
        select(Patient).options(joinedload(Patient.hospital))
    )
    patients = result.scalars().all()
    return [PatientResponse.model_validate(patient) for patient in patients]

async def get_patient(db: AsyncSession, patient_id: int):
    result = await db.execute(select(Patient).filter(Patient.id == patient_id))
    patient = result.scalars().first()
    return PatientResponse.model_validate(patient) if patient else None

async def create_patient(db: AsyncSession, patient_data: PatientCreate):
    result = await db.execute(
        text("SELECT patient_unique_id FROM patients ORDER BY id DESC LIMIT 1")
    )
    last_patient_id = result.scalar()

    if last_patient_id and last_patient_id.startswith("PAT"):
        last_number = int(last_patient_id[3:])
        new_patient_id = f"PAT{last_number + 1:04d}"
    else:
        new_patient_id = "PAT0001"

    patient_dict = patient_data.model_dump()
    if "patient_unique_id" not in patient_dict or not patient_dict["patient_unique_id"]:
        patient_dict["patient_unique_id"] = new_patient_id

    new_patient = Patient(**patient_dict)
    db.add(new_patient)
    await db.commit()
    await db.refresh(new_patient)

    return PatientResponse.model_validate(new_patient)

async def update_patient(db: AsyncSession, patient_id: int, patient_data: PatientUpdate):
    result = await db.execute(select(Patient).filter(Patient.id == patient_id))
    patient = result.scalars().first()
    if not patient:
        return None

    for key, value in patient_data.model_dump(exclude_unset=True).items():
        setattr(patient, key, value)

    await db.commit()
    await db.refresh(patient)
    return PatientResponse.model_validate(patient)

async def delete_patient(db: AsyncSession, patient_id: int):
    result = await db.execute(select(Patient).filter(Patient.id == patient_id))
    patient = result.scalars().first()
    if not patient:
        return None

    await db.delete(patient)
    await db.commit()
    return {"message": "Patient deleted successfully"}

async def search_patients(db: AsyncSession, search_criteria: dict):
    query = select(Patient)
    for field, value in search_criteria.items():
        if hasattr(Patient, field):
            if isinstance(value, int):
                query = query.filter(getattr(Patient, field) == value)
            else:
                query = query.filter(getattr(Patient, field).ilike(f"%{value}%"))

    result = await db.execute(query)
    patients = result.scalars().all()
    return [PatientResponse.model_validate(patient) for patient in patients]