from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.admission import AdmissionCreate, AdmissionUpdate, AdmissionOut
from app.crud.admission import (
    create_admission, get_admission, get_all_admissions, update_admission, delete_admission
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