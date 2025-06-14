from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload, selectinload
from app.models.patient import Patient
from app.models.hospital import Hospital
from app.schemas.patient import PatientCreate, PatientUpdate, PatientResponse
import uuid
from datetime import datetime
from sqlalchemy import text
from typing import List

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

    if last_patient_id and last_patient_id.isdigit():
        new_patient_id = str(int(last_patient_id) + 1)
    else:
        new_patient_id = "100001"

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

async def get_hospital_by_patient_id(db: AsyncSession, patient_id: int):
    result = await db.execute(
        select(Patient).filter(Patient.id == patient_id)
    )
    patient = result.scalars().first()
    if not patient or not patient.hospital_id:
        return None

    result = await db.execute(
        select(Hospital)
        .options(
            selectinload(Hospital.permissions),
            selectinload(Hospital.hospital_payments)
        )
        .filter(Hospital.id == patient.hospital_id)
    )
    hospital = result.scalars().first()
    return hospital

def calculate_age(date_of_birth: str) -> int:
    if not date_of_birth:
        return None
    try:
        dob = datetime.strptime(date_of_birth, "%Y-%m-%d")
        today = datetime.today()
        return today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    except ValueError:
        return None

async def get_patients_by_hospital_id(db: AsyncSession, hospital_id: int) -> List[dict]:
    result = await db.execute(
        select(Patient).filter(Patient.hospital_id == hospital_id)
    )
    patients = result.scalars().all()

    response = []
    for patient in patients:
        full_name = " ".join(filter(None, [patient.first_name, patient.middle_name, patient.last_name]))
        response.append({
            "id": patient.id,
            "uniqueId": patient.patient_unique_id,
            "name": full_name,
            "phone": patient.phone_number,
            "age": calculate_age(patient.date_of_birth),
            "gender": patient.gender
        })

    return response