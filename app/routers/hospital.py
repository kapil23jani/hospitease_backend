from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.hospital import HospitalCreate, HospitalUpdate, HospitalResponse
from app.crud.hospital import create_hospital, get_hospital, get_hospitals, delete_hospital

router = APIRouter()

@router.post("/", response_model=HospitalResponse)
async def create_hospital_route(hospital: HospitalCreate, db: Session = Depends(get_db)):
    return await create_hospital(db, hospital)

@router.get("/", response_model=List[HospitalResponse])
async def get_all_hospitals_route(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return await get_hospitals(db, skip, limit)

@router.get("/{hospital_id}", response_model=HospitalResponse)
async def get_hospital_route(hospital_id: int, db: Session = Depends(get_db)):
    hospital = await get_hospital(db, hospital_id)
    if not hospital:
        raise HTTPException(status_code=404, detail="Hospital not found")
    return hospital

@router.delete("/{hospital_id}", response_model=HospitalResponse)
async def delete_hospital_route(hospital_id: int, db: Session = Depends(get_db)):
    hospital = await delete_hospital(db, hospital_id)
    if not hospital:
        raise HTTPException(status_code=404, detail="Hospital not found")
    return hospital

@router.put("/{hospital_id}", response_model=HospitalResponse)
async def update_hospital_route(hospital_id: int, hospital_update: HospitalUpdate, db: AsyncSession = Depends(get_db)):
    from app.crud.hospital import update_hospital
    hospital = await update_hospital(db, hospital_id, hospital_update)
    if not hospital:
        raise HTTPException(status_code=404, detail="Hospital not found")
    return hospital
