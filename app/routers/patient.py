from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.patient import get_patients, get_patient, create_patient, update_patient, delete_patient, search_patients
from app.schemas.patient import PatientCreate, PatientUpdate, PatientResponse
from typing import List, Optional

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

@router.get("/search/", response_model=List[PatientResponse])
async def search_patients_api(
    id: Optional[int] = None,
    patient_unique_id: Optional[str] = None,
    name: Optional[str] = None,
    email: Optional[str] = None,
    phone: Optional[str] = None,
    db: AsyncSession = Depends(get_db)
):
    search_criteria = {}
    if id:
        search_criteria["id"] = id
    if patient_unique_id:
        search_criteria["patient_unique_id"] = patient_unique_id
    if name:
        search_criteria["name"] = name
    if email:
        search_criteria["email"] = email
    if phone:
        search_criteria["phone"] = phone

    patients = await search_patients(db, search_criteria)
    return patients