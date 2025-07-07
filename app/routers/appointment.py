from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from fastapi.responses import JSONResponse
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from pydantic import BaseModel
from fastapi import APIRouter, Depends, Query
from fastapi import APIRouter, UploadFile, File, Form, HTTPException, Depends


from app.crud.appointment import (
    get_appointments_by_date_range, create_appointment, get_appointments, get_appointment_by_id, get_appointments_by_hospital_id,
    update_appointment, delete_appointment, get_appointments_by_doctor_id,
    get_appointments_by_patient_id, get_listing_appointments, get_doctor_by_appointment_id, get_patient_by_appointment_id, get_grouped_appointments
)
from app.schemas.appointment import AppointmentCreate, AppointmentUpdate, AppointmentResponse, AppointmentListingResponse
from app.schemas.patient import PatientResponse
from app.schemas.doctor import DoctorResponse
from app.crud.appointment import transcribe_and_parse_prescription
from typing import List

router = APIRouter()

@router.post("/", response_model=AppointmentResponse)
async def create_new_appointment(appointment: AppointmentCreate, db: AsyncSession = Depends(get_db)):
    return await create_appointment(db, appointment)

@router.get("/", response_model=List[AppointmentResponse])
async def list_appointments(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_appointments(db, skip, limit)

@router.get("/listing", response_model=List[AppointmentListingResponse])
async def listing_appointments(
    skip: int = Query(0),
    limit: int = Query(100),
    dateRange: str = Query(None),
    doctorId: str = Query(None),
    status: str = Query(None),
    search: str = Query(None),
    appointmentType: str = Query(None),
    problem: str = Query(None),
    db: AsyncSession = Depends(get_db)
):
    return await get_listing_appointments(
        db=db,
        skip=skip,
        limit=limit,
        dateRange=dateRange,
        doctorId=doctorId,
        status=status,
        search=search,
        appointmentType=appointmentType,
        problem=problem
    )

@router.get("/grouped/list", response_model=dict)
async def grouped(db: AsyncSession = Depends(get_db)):
    return await get_grouped_appointments(db)

@router.get("/grouped-by-doctor", response_model=dict)
async def grouped_appointments_by_doctor(
    doctor_id: int = Query(..., description="Doctor ID"),
    db: AsyncSession = Depends(get_db)
):
    return await get_grouped_appointments(db, doctor_id=doctor_id)

@router.get("/grouped-by-patient", response_model=dict)
async def grouped_appointments_by_patient(
    patient_id: int = Query(..., description="Patient ID"),
    db: AsyncSession = Depends(get_db)
):
    return await get_grouped_appointments(db, patient_id=patient_id)


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

@router.get("/{appointment_id}/patient", response_model=PatientResponse)
async def fetch_patient_by_appointment(appointment_id: int, db: AsyncSession = Depends(get_db)):
    patient = await get_patient_by_appointment_id(db, appointment_id)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    return patient

@router.get("/{appointment_id}/doctor", response_model=DoctorResponse)
async def fetch_doctor_by_appointment(appointment_id: int, db: AsyncSession = Depends(get_db)):
    doctor = await get_doctor_by_appointment_id(db, appointment_id)
    if not doctor:
        raise HTTPException(status_code=404, detail="Doctor not found")
    return doctor


class DateRangeRequest(BaseModel):
    start_date: str  # "YYYY-MM-DD"
    end_date: str  # "YYYY-MM-DD"

@router.post("/appointments/by-date-range")
async def get_appointments_by_date_range_endpoint(
    date_range: DateRangeRequest, db: AsyncSession = Depends(get_db)
):
    try:
        appointments = await get_appointments_by_date_range(
            db,
            start_date=date_range.start_date,
            end_date=date_range.end_date,
        )
        if not appointments:
            raise HTTPException(status_code=404, detail="No appointments found in this date range")
        return {"appointments": appointments}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
    
@router.get("/by_hospital/{hospital_id}", response_model=List[dict])
async def list_appointments_by_hospital(hospital_id: int, start_date: str, end_date: str, db: AsyncSession = Depends(get_db)):
    appointments = await get_appointments_by_hospital_id(db, hospital_id, start_date, end_date)
    if not appointments:
        raise HTTPException(status_code=404, detail="No appointments found for this hospital.")
    return appointments

@router.post("/{appointment_id}/ai_prescription")
async def ai_prescription(
    appointment_id: int,
    audio: UploadFile = File(...),
    language: str = Form("en"),
    db: AsyncSession = Depends(get_db)
):
    try:
        result = await transcribe_and_parse_prescription(db, appointment_id, audio)
        return JSONResponse(result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))