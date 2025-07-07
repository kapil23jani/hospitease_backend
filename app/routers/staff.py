from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.staff import StaffCreate, StaffUpdate, StaffOut
from app.crud.staffs import (
    create_staff,
    get_staff,
    get_all_staff,
    update_staff,
    delete_staff,
    get_staff_by_hospital,
)
from app.crud.staffs import create_staff as crud_create_staff  # <-- import with alias

router = APIRouter(prefix="/staff", tags=["Staff"])


@router.post("/", response_model=StaffOut)
async def create_staff(staff: StaffCreate, db: AsyncSession = Depends(get_db)):
    return await crud_create_staff(db, staff)  # <-- call the CRUD function


@router.get("/{staff_id}", response_model=StaffOut)
async def read_staff(staff_id: int, db: AsyncSession = Depends(get_db)):
    db_staff = await get_staff(db, staff_id)
    if not db_staff:
        raise HTTPException(status_code=404, detail="Staff not found")
    return db_staff


@router.get("/", response_model=List[StaffOut])
async def read_all_staff(
    skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)
):
    return await get_all_staff(db, skip, limit)


@router.put("/{staff_id}", response_model=StaffOut)
async def update_staff(
    staff_id: int, staff: StaffUpdate, db: AsyncSession = Depends(get_db)
):
    return await update_staff(db, staff_id, staff)


@router.delete("/{staff_id}")
async def delete_staff(staff_id: int, db: AsyncSession = Depends(get_db)):
    await delete_staff(db, staff_id)
    return {"ok": True}


@router.get("/by-hospital/{hospital_id}", response_model=List[StaffOut])
async def fetch_staff_by_hospital(
    hospital_id: int,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db),
):
    staff = await get_staff_by_hospital(db, hospital_id, skip, limit)
    if not staff:
        raise HTTPException(status_code=404, detail="No staff found for this hospital")
    return staff