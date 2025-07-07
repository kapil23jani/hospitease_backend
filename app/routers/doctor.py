from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.doctor import create_doctor, get_doctors, get_doctor_by_id, update_doctor, delete_doctor, get_doctors_by_hospital
from app.schemas.doctor import DoctorCreate, DoctorUpdate, DoctorResponse
from typing import List
from app.models.doctor import Doctor
from app.models.hospital import Hospital
from sqlalchemy.future import select

router = APIRouter()

@router.post("/", response_model=DoctorResponse)
async def create_new_doctor(doctor: DoctorCreate, db: AsyncSession = Depends(get_db)):
    return await create_doctor(db, doctor)

@router.get("/", response_model=List[DoctorResponse])
async def list_doctors(skip: int = 0, limit: int = 10, db: AsyncSession = Depends(get_db)):
    return await get_doctors(db, skip, limit)

@router.get("/{doctor_id}", response_model=DoctorResponse)
async def get_doctor(doctor_id: int, db: AsyncSession = Depends(get_db)):
    doctor = await get_doctor_by_id(db, doctor_id)
    if not doctor:
        raise HTTPException(status_code=404, detail="Doctor not found")
    return doctor

@router.put("/{doctor_id}", response_model=DoctorResponse)
async def update_doctor_details(doctor_id: int, doctor: DoctorUpdate, db: AsyncSession = Depends(get_db)):
    updated_doctor = await update_doctor(db, doctor_id, doctor)
    if not updated_doctor:
        raise HTTPException(status_code=404, detail="Doctor not found")
    return updated_doctor

@router.delete("/{doctor_id}")
async def delete_doctor_entry(doctor_id: int, db: AsyncSession = Depends(get_db)):
    success = await delete_doctor(db, doctor_id)
    if not success:
        raise HTTPException(status_code=404, detail="Doctor not found")
    return {"message": "Doctor deleted successfully"}

@router.get("/{doctor_id}", response_model=DoctorResponse)
async def get_doctor_with_hospital(doctor_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Doctor)
        .join(Hospital)
        .where(Doctor.id == doctor_id)
    )
    doctor = result.scalar_one_or_none()

    if not doctor:
        raise HTTPException(status_code=404, detail="Doctor not found")
    return doctor

@router.get("/by-hospital/{hospital_id}", response_model=List[DoctorResponse])
async def read_doctors_by_hospital(hospital_id: int, db: AsyncSession = Depends(get_db)):
    doctors = await get_doctors_by_hospital(db, hospital_id)
    return doctors