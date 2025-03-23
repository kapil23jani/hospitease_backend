from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.appointment import (
    create_appointment, get_appointments, get_appointment_by_id,
    update_appointment, delete_appointment, get_appointments_by_doctor_id,
    get_appointments_by_patient_id, get_listing_appointments
)
from app.schemas.appointment import AppointmentCreate, AppointmentUpdate, AppointmentResponse, AppointmentListingResponse
from typing import List

router = APIRouter()

@router.post("/", response_model=AppointmentResponse)
async def create_new_appointment(appointment: AppointmentCreate, db: AsyncSession = Depends(get_db)):
    return await create_appointment(db, appointment)

@router.get("/", response_model=List[AppointmentResponse])
async def list_appointments(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_appointments(db, skip, limit)

@router.get("/listing", response_model=List[AppointmentListingResponse])
async def list_appointments(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_listing_appointments(db, skip, limit)

@router.get("/{appointment_id}", response_model=AppointmentResponse)
async def get_appointment(appointment_id: int, db: AsyncSession = Depends(get_db)):
    appointment = await get_appointment_by_id(db, appointment_id)
    if not appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")
    return appointment

@router.put("/{appointment_id}", response_model=AppointmentResponse)
async def update_appointment_details(appointment_id: int, appointment: AppointmentUpdate, db: AsyncSession = Depends(get_db)):
    updated_appointment = await update_appointment(db, appointment_id, appointment)
    if not updated_appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")
    return updated_appointment

@router.delete("/{appointment_id}")
async def delete_appointment_entry(appointment_id: int, db: AsyncSession = Depends(get_db)):
    success = await delete_appointment(db, appointment_id)
    if not success:
        raise HTTPException(status_code=404, detail="Appointment not found")
    return {"message": "Appointment deleted successfully"}

@router.get("/doctor/{doctor_id}", response_model=List[AppointmentResponse])
async def list_appointments_by_doctor(doctor_id: int, skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_appointments_by_doctor_id(db, doctor_id, skip, limit)

@router.get("/patient/{patient_id}", response_model=List[AppointmentResponse])
async def list_appointments_by_patient(patient_id: int, skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_appointments_by_patient_id(db, patient_id, skip, limit)
