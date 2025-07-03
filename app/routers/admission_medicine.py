from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.admission_medicine import AdmissionMedicineCreate, AdmissionMedicineUpdate, AdmissionMedicineOut
from app.crud.admission_medicine import (
    create_admission_medicine, get_admission_medicine, get_all_admission_medicines, update_admission_medicine, delete_admission_medicine, get_medicines_by_admission_id
)

router = APIRouter(prefix="/admission-medicines", tags=["Admission Medicines"])

@router.post("/", response_model=AdmissionMedicineOut)
async def create_admission_medicine_route(medicine: AdmissionMedicineCreate, db: AsyncSession = Depends(get_db)):
    return await create_admission_medicine(db, medicine)

@router.get("/{medicine_id}", response_model=AdmissionMedicineOut)
async def read_admission_medicine(medicine_id: int, db: AsyncSession = Depends(get_db)):
    db_medicine = await get_admission_medicine(db, medicine_id)
    if not db_medicine:
        raise HTTPException(status_code=404, detail="Admission medicine not found")
    return db_medicine

@router.get("/", response_model=List[AdmissionMedicineOut])
async def read_all_admission_medicines(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_all_admission_medicines(db, skip, limit)

@router.put("/{medicine_id}", response_model=AdmissionMedicineOut)
async def update_admission_medicine_route(medicine_id: int, medicine: AdmissionMedicineUpdate, db: AsyncSession = Depends(get_db)):
    return await update_admission_medicine(db, medicine_id, medicine)

@router.delete("/{medicine_id}")
async def delete_admission_medicine_route(medicine_id: int, db: AsyncSession = Depends(get_db)):
    await delete_admission_medicine(db, medicine_id)
    return {"ok": True}

@router.get("/by-admission/{admission_id}", response_model=List[AdmissionMedicineOut])
async def fetch_medicines_by_admission(
    admission_id: int,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db)
):
    medicines = await get_medicines_by_admission_id(db, admission_id, skip, limit)
    if not medicines:
        raise HTTPException(status_code=404, detail="No medicines found for this admission")
    return medicines