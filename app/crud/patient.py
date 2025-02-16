from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload
from app.models.patient import Patient
from app.schemas.patient import PatientCreate, PatientUpdate, PatientResponse

async def get_patients(db: AsyncSession):
    result = await db.execute(
        select(Patient).options(joinedload(Patient.hospital))  # ✅ Ensures hospital data is preloaded
    )
    patients = result.scalars().all()
    return [PatientResponse.model_validate(patient) for patient in patients]

async def get_patient(db: AsyncSession, patient_id: int):
    result = await db.execute(select(Patient).filter(Patient.id == patient_id))
    patient = result.scalars().first()
    return PatientResponse.model_validate(patient) if patient else None

async def create_patient(db: AsyncSession, patient_data: PatientCreate):
    new_patient = Patient(**patient_data.model_dump())
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
