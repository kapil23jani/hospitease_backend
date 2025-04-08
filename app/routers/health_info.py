from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.health_info import HealthInfoCreate, HealthInfoUpdate, HealthInfoResponse
from app.crud.health_info import (
    create_health_info, get_health_info_by_appointment, update_health_info, delete_health_info, get_health_info_by_appointment_id
)

router = APIRouter()

@router.post("/", response_model=HealthInfoResponse)
async def add_health_info(health_info_data: HealthInfoCreate, db: AsyncSession = Depends(get_db)):
    return await create_health_info(db, health_info_data)

@router.get("/{id}", response_model=HealthInfoResponse)
async def fetch_health_info(id: int, db: AsyncSession = Depends(get_db)):
    health_info = await get_health_info_by_appointment(db, id)
    if not health_info:
        raise HTTPException(status_code=404, detail="Health info not found")
    return health_info

@router.put("/{id}", response_model=HealthInfoResponse)
async def modify_health_info(id: int, update_data: HealthInfoUpdate, db: AsyncSession = Depends(get_db)):
    updated_info = await update_health_info(db, id, update_data)
    if not updated_info:
        raise HTTPException(status_code=404, detail="Health info not found")
    return updated_info

@router.delete("/{id}")
async def remove_health_info(id: int, db: AsyncSession = Depends(get_db)):
    deleted_info = await delete_health_info(db, id)
    if not deleted_info:
        raise HTTPException(status_code=404, detail="Health info not found")
    return {"message": "Health info deleted successfully"}

@router.get("/", response_model=HealthInfoResponse)
async def fetch_health_info(appointment_id: int, db: AsyncSession = Depends(get_db)):
    health_info = await get_health_info_by_appointment_id(db, appointment_id)
    if not health_info:
        raise HTTPException(status_code=404, detail="Health info not found")
    return health_info