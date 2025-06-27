from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.bed_type import BedTypeCreate, BedTypeUpdate, BedTypeOut
from app.crud.bed_type import (
    create_bed_type, get_bed_type, get_all_bed_types, update_bed_type, delete_bed_type
)

router = APIRouter(prefix="/bed-types", tags=["Bed Types"])

@router.post("/", response_model=BedTypeOut)
async def create_bed_type_route(bed_type: BedTypeCreate, db: AsyncSession = Depends(get_db)):
    return await create_bed_type(db, bed_type)

@router.get("/{bed_type_id}", response_model=BedTypeOut)
async def read_bed_type(bed_type_id: int, db: AsyncSession = Depends(get_db)):
    db_bed_type = await get_bed_type(db, bed_type_id)
    if not db_bed_type:
        raise HTTPException(status_code=404, detail="Bed type not found")
    return db_bed_type

@router.get("/", response_model=List[BedTypeOut])
async def read_all_bed_types(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_all_bed_types(db, skip, limit)

@router.put("/{bed_type_id}", response_model=BedTypeOut)
async def update_bed_type_route(bed_type_id: int, bed_type: BedTypeUpdate, db: AsyncSession = Depends(get_db)):
    return await update_bed_type(db, bed_type_id, bed_type)

@router.delete("/{bed_type_id}")
async def delete_bed_type_route(bed_type_id: int, db: AsyncSession = Depends(get_db)):
    await delete_bed_type(db, bed_type_id)
    return {"ok": True}