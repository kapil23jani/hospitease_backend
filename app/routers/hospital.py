from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.hospital import HospitalCreate
from app.crud.hospital import create_hospital, get_hospital

router = APIRouter()

@router.post("/", response_model=HospitalCreate)
async def create_hospital_api(hospital: HospitalCreate, db: AsyncSession = Depends(get_db)):
    return await create_hospital(db, hospital)

@router.get("/{hospital_id}", response_model=HospitalCreate)
async def get_hospital_api(hospital_id: int, db: AsyncSession = Depends(get_db)):
    hospital = await get_hospital(db, hospital_id)
    if not hospital:
        raise HTTPException(status_code=404, detail="Hospital not found")
    return hospital
