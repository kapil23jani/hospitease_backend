from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.family_history import FamilyHistoryCreate, FamilyHistoryUpdate, FamilyHistoryResponse
from app.crud.family_history import (
    create_family_history, get_family_history_by_appointment, update_family_history, delete_family_history
)

router = APIRouter()

# ✅ Create Family History Record
@router.post("/", response_model=FamilyHistoryResponse)
async def add_family_history(data: FamilyHistoryCreate, db: AsyncSession = Depends(get_db)):
    return await create_family_history(db, data)

# ✅ Get Family History by Appointment ID
@router.get("/{appointment_id}", response_model=list[FamilyHistoryResponse])
async def fetch_family_history(appointment_id: int, db: AsyncSession = Depends(get_db)):
    records = await get_family_history_by_appointment(db, appointment_id)
    if not records:
        raise HTTPException(status_code=404, detail="No family history records found for this appointment")
    return records

# ✅ Update Family History Record
@router.put("/{family_history_id}", response_model=FamilyHistoryResponse)
async def modify_family_history(family_history_id: int, data: FamilyHistoryUpdate, db: AsyncSession = Depends(get_db)):
    return await update_family_history(db, family_history_id, data)

# ✅ Delete Family History Record
@router.delete("/{family_history_id}")
async def remove_family_history(family_history_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_family_history(db, family_history_id)
