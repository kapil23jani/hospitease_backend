from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.admission_discharge import (
    AdmissionDischargeCreate, AdmissionDischargeUpdate, AdmissionDischargeOut
)
from app.crud.admission_discharge import (
    create_admission_discharge, get_admission_discharge, get_discharges_by_admission_id,
    update_admission_discharge, delete_admission_discharge, get_all_discharges
)

router = APIRouter(prefix="/admission-discharges", tags=["Admission Discharges"])

@router.post("/", response_model=AdmissionDischargeOut)
async def create_discharge_route(discharge: AdmissionDischargeCreate, db: AsyncSession = Depends(get_db)):
    return await create_admission_discharge(db, discharge)

@router.get("/{discharge_id}", response_model=AdmissionDischargeOut)
async def read_discharge(discharge_id: int, db: AsyncSession = Depends(get_db)):
    discharge = await get_admission_discharge(db, discharge_id)
    if not discharge:
        raise HTTPException(status_code=404, detail="Discharge not found")
    return discharge

@router.get("/admission/{admission_id}", response_model=AdmissionDischargeOut)
async def read_discharge_by_admission(admission_id: int, db: AsyncSession = Depends(get_db)):
    discharges = await get_discharges_by_admission_id(db, admission_id)
    if not discharges:
        raise HTTPException(status_code=404, detail="Discharge not found for this admission")
    return discharges[-1]

@router.put("/{discharge_id}", response_model=AdmissionDischargeOut)
async def update_discharge(discharge_id: int, discharge: AdmissionDischargeUpdate, db: AsyncSession = Depends(get_db)):
    return await update_admission_discharge(db, discharge_id, discharge)

@router.delete("/{discharge_id}")
async def delete_discharge(discharge_id: int, db: AsyncSession = Depends(get_db)):
    await delete_admission_discharge(db, discharge_id)
    return {"ok": True}

@router.get("/", response_model=List[AdmissionDischargeOut])
async def list_all_discharges(db: AsyncSession = Depends(get_db)):
    return await get_all_discharges(db)