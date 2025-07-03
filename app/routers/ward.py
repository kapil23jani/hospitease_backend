from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.ward import WardCreate, WardUpdate, WardOut
from app.crud.ward import (
    create_ward, get_ward, get_all_wards, update_ward, delete_ward, get_wards_by_hospital_id
)

router = APIRouter(prefix="/wards", tags=["Wards"])

@router.post("/", response_model=WardOut)
async def create_ward_route(ward: WardCreate, db: AsyncSession = Depends(get_db)):
    return await create_ward(db, ward)

@router.get("/{ward_id}", response_model=WardOut)
async def read_ward(ward_id: int, db: AsyncSession = Depends(get_db)):
    db_ward = await get_ward(db, ward_id)
    if not db_ward:
        raise HTTPException(status_code=404, detail="Ward not found")
    return db_ward

@router.get("/", response_model=List[WardOut])
async def read_all_wards(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_all_wards(db, skip, limit)

@router.put("/{ward_id}", response_model=WardOut)
async def update_ward_route(ward_id: int, ward: WardUpdate, db: AsyncSession = Depends(get_db)):
    return await update_ward(db, ward_id, ward)

@router.delete("/{ward_id}")
async def delete_ward_route(ward_id: int, db: AsyncSession = Depends(get_db)):
    await delete_ward(db, ward_id)
    return {"ok": True}

@router.get("/by-hospital/{hospital_id}", response_model=List[WardOut])
async def fetch_wards_by_hospital(
    hospital_id: int,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db)
):
    wards = await get_wards_by_hospital_id(db, hospital_id, skip, limit)
    if not wards:
        raise HTTPException(status_code=404, detail="No wards found for this hospital")
    return wards