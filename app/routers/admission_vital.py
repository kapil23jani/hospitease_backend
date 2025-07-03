from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.admission_vital import AdmissionVitalCreate, AdmissionVitalUpdate, AdmissionVitalOut
from app.crud.admission_vital import (
    create_admission_vital, get_admission_vital, get_all_admission_vitals, update_admission_vital, delete_admission_vital, get_vitals_by_admission_id
)

router = APIRouter(prefix="/admission-vitals", tags=["Admission Vitals"])

@router.post("/", response_model=AdmissionVitalOut)
async def create_admission_vital_route(vital: AdmissionVitalCreate, db: AsyncSession = Depends(get_db)):
    return await create_admission_vital(db, vital)

@router.get("/{vital_id}", response_model=AdmissionVitalOut)
async def read_admission_vital(vital_id: int, db: AsyncSession = Depends(get_db)):
    db_vital = await get_admission_vital(db, vital_id)
    if not db_vital:
        raise HTTPException(status_code=404, detail="Admission vital not found")
    return db_vital

@router.get("/", response_model=List[AdmissionVitalOut])
async def read_all_admission_vitals(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_all_admission_vitals(db, skip, limit)

@router.put("/{vital_id}", response_model=AdmissionVitalOut)
async def update_admission_vital_route(vital_id: int, vital: AdmissionVitalUpdate, db: AsyncSession = Depends(get_db)):
    return await update_admission_vital(db, vital_id, vital)

@router.delete("/{vital_id}")
async def delete_admission_vital_route(vital_id: int, db: AsyncSession = Depends(get_db)):
    await delete_admission_vital(db, vital_id)
    return {"ok": True}

@router.get("/by-admission/{admission_id}", response_model=List[AdmissionVitalOut])
async def fetch_vitals_by_admission(
    admission_id: int,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db)
):
    vitals = await get_vitals_by_admission_id(db, admission_id, skip, limit)
    if not vitals:
        raise HTTPException(status_code=404, detail="No vitals found for this admission")
    return vitals