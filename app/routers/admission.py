from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
from app.database import get_db
from app.schemas.admission import AdmissionCreate, AdmissionUpdate, AdmissionOut
from app.crud.admission import (
    create_admission, get_admission, get_all_admissions, update_admission, delete_admission, get_admissions_by_hospital_id, get_admissions_filtered, get_admissions_by_doctor_id,  get_admissions_by_patient_id , get_admissions_by_staff_id
)

router = APIRouter(prefix="/admissions", tags=["Admissions"])

@router.post("/", response_model=AdmissionOut)
async def create_admission_route(admission: AdmissionCreate, db: AsyncSession = Depends(get_db)):
    return await create_admission(db, admission)

@router.get("/{admission_id}", response_model=AdmissionOut)
async def read_admission(admission_id: int, db: AsyncSession = Depends(get_db)):
    db_admission = await get_admission(db, admission_id)
    if not db_admission:
        raise HTTPException(status_code=404, detail="Admission not found")
    return db_admission

@router.get("/", response_model=List[AdmissionOut])
async def read_all_admissions(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_all_admissions(db, skip, limit)

@router.put("/{admission_id}", response_model=AdmissionOut)
async def update_admission_route(admission_id: int, admission: AdmissionUpdate, db: AsyncSession = Depends(get_db)):
    return await update_admission(db, admission_id, admission)

@router.delete("/{admission_id}")
async def delete_admission_route(admission_id: int, db: AsyncSession = Depends(get_db)):
    await delete_admission(db, admission_id)
    return {"ok": True}

@router.get("/filter", response_model=List[AdmissionOut])
async def filter_admissions(
    doctor_id: Optional[int] = Query(None),
    staff_id: Optional[int] = Query(None),
    patient_id: Optional[int] = Query(None),
    db: AsyncSession = Depends(get_db)
):
    if patient_id is not None and isinstance(patient_id, str) and patient_id.isdigit():
        patient_id = int(patient_id)
    print(f"doctor_id={doctor_id}, staff_id={staff_id}, patient_id={patient_id}")
    return await get_admissions_filtered(db, doctor_id, staff_id, patient_id)

@router.get("/by-hospital/{hospital_id}", response_model=List[AdmissionOut])
async def get_admissions_by_hospital(hospital_id: int, db: AsyncSession = Depends(get_db)):
    return await get_admissions_by_hospital_id(db, hospital_id)

@router.get("/by-doctor/{doctor_id}", response_model=List[AdmissionOut])
async def get_admissions_by_doctor(doctor_id: int, db: AsyncSession = Depends(get_db)):
    return await get_admissions_by_doctor_id(db, doctor_id)

@router.get("/by-staff/{staff_id}", response_model=List[AdmissionOut])
async def get_admissions_by_staff(staff_id: int, db: AsyncSession = Depends(get_db)):
    return await get_admissions_by_staff_id(db, staff_id)

@router.get("/by-patient/{patient_id}", response_model=List[AdmissionOut])
async def get_admissions_by_patient(patient_id: int, db: AsyncSession = Depends(get_db)):
    return await get_admissions_by_patient_id(db, patient_id)