from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.patient import Patient
from app.schemas.patient import PatientCreate

async def create_patient(db: AsyncSession, patient_data: PatientCreate):
    new_patient = Patient(**patient_data.dict())
    db.add(new_patient)
    await db.commit()
    await db.refresh(new_patient)
    return new_patient
