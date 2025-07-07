from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.appointment_medicine import MedicineCreate, MedicineUpdate, MedicineOut
from app.crud.appointment_medicine import create_medicine, get_medicines_by_appointment_id, get_medicine_by_id, update_medicine, delete_medicine, get_all_medicines_by_patient_id

router = APIRouter()

@router.post("/", response_model=MedicineOut)
async def create_medicine_api(medicine: MedicineCreate, db: AsyncSession = Depends(get_db)):
    return await create_medicine(db, medicine)

@router.get("/{appointment_id}", response_model=List[MedicineOut])
async def get_medicines_by_appointment(appointment_id: int, db: AsyncSession = Depends(get_db)):
    return await get_medicines_by_appointment_id(db, appointment_id)

@router.get("/single/{medicine_id}", response_model=MedicineOut)
async def get_medicine_by_id_api(medicine_id: int, db: AsyncSession = Depends(get_db)):
    medicine = await get_medicine_by_id(db, medicine_id)
    if not medicine:
        raise HTTPException(status_code=404, detail="Medicine not found")
    return medicine

@router.put("/{medicine_id}", response_model=MedicineOut)
async def update_medicine_api(medicine_id: int, medicine_data: MedicineUpdate, db: AsyncSession = Depends(get_db)):
    updated_medicine = await update_medicine(db, medicine_id, medicine_data)
    if not updated_medicine:
        raise HTTPException(status_code=404, detail="Medicine not found")
    return updated_medicine

@router.delete("/{medicine_id}")
async def delete_medicine_api(medicine_id: int, db: AsyncSession = Depends(get_db)):
    deleted_medicine = await delete_medicine(db, medicine_id)
    if not deleted_medicine:
        raise HTTPException(status_code=404, detail="Medicine not found")
    return {"message": "Medicine deleted successfully"}

@router.get("/patients/{patient_id}/medicines")
async def get_patient_medicines(patient_id: int, db: AsyncSession = Depends(get_db)):
    return await get_all_medicines_by_patient_id(db, patient_id)
