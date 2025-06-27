from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.bed import BedCreate, BedUpdate, BedOut
from app.crud.bed import (
    create_bed, get_bed, get_all_beds, update_bed, delete_bed
)

router = APIRouter(prefix="/beds", tags=["Beds"])

@router.post("/", response_model=BedOut)
async def create_bed_route(bed: BedCreate, db: AsyncSession = Depends(get_db)):
    return await create_bed(db, bed)

@router.get("/{bed_id}", response_model=BedOut)
async def read_bed(bed_id: int, db: AsyncSession = Depends(get_db)):
    db_bed = await get_bed(db, bed_id)
    if not db_bed:
        raise HTTPException(status_code=404, detail="Bed not found")
    return db_bed

@router.get("/", response_model=List[BedOut])
async def read_all_beds(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_all_beds(db, skip, limit)

@router.put("/{bed_id}", response_model=BedOut)
async def update_bed_route(bed_id: int, bed: BedUpdate, db: AsyncSession = Depends(get_db)):
    return await update_bed(db, bed_id, bed)

@router.delete("/{bed_id}")
async def delete_bed_route(bed_id: int, db: AsyncSession = Depends(get_db)):
    await delete_bed(db, bed_id)
    return {"ok": True}