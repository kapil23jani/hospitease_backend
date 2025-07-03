from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.patient import get_patients, get_patient, create_patient, get_patients_by_hospital_id, update_patient, delete_patient, search_patients, get_hospital_by_patient_id, login_patient_by_mrd, get_patients_by_doctor_id
from app.schemas.patient import PatientCreate, PatientUpdate, PatientResponse, PatientBasicResponse
from typing import List, Optional
from app.schemas.hospital import HospitalResponse
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

@router.get("/{patient_id}/hospital", response_model=HospitalResponse)
async def read_hospital_by_patient_id(patient_id: int, db: AsyncSession = Depends(get_db)):
    hospital = await get_hospital_by_patient_id(db, patient_id)
    if not hospital:
        raise HTTPException(status_code=404, detail="Hospital not found for this patient")
    return hospital

@router.get("/by-hospital/{hospital_id}", response_model=List[PatientBasicResponse])
async def get_patients_by_hospital(
    hospital_id: int,
    db: AsyncSession = Depends(get_db)
):
    patients = await get_patients_by_hospital_id(db, hospital_id)
    if not patients:
        raise HTTPException(status_code=404, detail="No patients found for this hospital")
    return patients

@router.post("/login-mrd", response_model=PatientResponse)
async def login_by_mrd(
    mrd_number: int,
    password: str,
    db: AsyncSession = Depends(get_db)
):
    patient = await login_patient_by_mrd(db, mrd_number, password)
    if not patient:
        raise HTTPException(status_code=401, detail="Invalid MRD number or password")
    return patient

@router.get("/by-doctor/{doctor_id}", response_model=List[PatientResponse])
async def get_patients_by_doctor(
    doctor_id: int,
    db: AsyncSession = Depends(get_db)
):
    patients = await get_patients_by_doctor_id(db, doctor_id)
    if not patients:
        raise HTTPException(status_code=404, detail="No patients found for this doctor")
    return patients