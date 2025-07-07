from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.vital import VitalCreate, VitalResponse
from app.crud.vital import create_vital, get_vitals_by_appointment, get_vital_by_id, update_vital, delete_vital

router = APIRouter()

@router.post("", response_model=VitalResponse)
async def add_vital(vital_data: VitalCreate, db: AsyncSession = Depends(get_db)):
    """Create a new vital record."""
    return await create_vital(db, vital_data)

@router.get("/{vital_id}", response_model=VitalResponse)
async def fetch_vital(vital_id: int, db: AsyncSession = Depends(get_db)):
    """Fetch a single vital record."""
    vital = await get_vital_by_id(db, vital_id)
    if not vital:
        raise HTTPException(status_code=404, detail="Vital not found")
    return vital

@router.get("", response_model=List[VitalResponse])
async def fetch_vitals(appointment_id: int, db: AsyncSession = Depends(get_db)):
    """Fetch all vitals for a specific appointment."""
    return await get_vitals_by_appointment(db, appointment_id)

@router.put("/{vital_id}", response_model=VitalResponse)
async def modify_vital(vital_id: int, vital_data: VitalCreate, db: AsyncSession = Depends(get_db)):
    """Update a vital record."""
    updated_vital = await update_vital(db, vital_id, vital_data)
    if not updated_vital:
        raise HTTPException(status_code=404, detail="Vital not found")
    return updated_vital

@router.delete("/{vital_id}")
async def remove_vital(vital_id: int, db: AsyncSession = Depends(get_db)):
    """Delete a vital record."""
    deleted_vital = await delete_vital(db, vital_id)
    if not deleted_vital:
        raise HTTPException(status_code=404, detail="Vital not found")
    return {"message": "Vital deleted successfully"}
