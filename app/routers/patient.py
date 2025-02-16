from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.patient import get_patients, get_patient, create_patient, update_patient, delete_patient
from app.schemas.patient import PatientCreate, PatientUpdate, PatientResponse
from typing import List

router = APIRouter()

@router.get("/", response_model=List[PatientResponse])
async def read_patients(db: AsyncSession = Depends(get_db)):
    return await get_patients(db)

@router.get("/{patient_id}", response_model=PatientResponse)
async def read_patient(patient_id: int, db: AsyncSession = Depends(get_db)):
    patient = await get_patient(db, patient_id)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    return patient

@router.post("/", response_model=PatientResponse)
async def create_new_patient(patient_data: PatientCreate, db: AsyncSession = Depends(get_db)):
    return await create_patient(db, patient_data)

@router.put("/{patient_id}", response_model=PatientResponse)
async def update_existing_patient(patient_id: int, patient_data: PatientUpdate, db: AsyncSession = Depends(get_db)):
    patient = await update_patient(db, patient_id, patient_data)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    return patient

@router.delete("/{patient_id}")
async def delete_existing_patient(patient_id: int, db: AsyncSession = Depends(get_db)):
    result = await delete_patient(db, patient_id)
    if not result:
        raise HTTPException(status_code=404, detail="Patient not found")
    return result
