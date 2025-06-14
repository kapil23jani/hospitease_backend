from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.schemas.hospital_perimissions import HospitalPermissionCreate, HospitalPermissionResponse, HospitalPermissionBulkCreate
from app.crud.hospital_permissions import add_permissions_to_hospital, get_permissions_for_hospital
from app.database import get_db

router = APIRouter(prefix="", tags=["Hospital Permissions"])

# @router.post("/", response_model=HospitalPermissionResponse)
# async def add_permission(hp: HospitalPermissionCreate, db: AsyncSession = Depends(get_db)):
#     return await add_permission_to_hospital(db, hp)

@router.get("/{hospital_id}", response_model=List[HospitalPermissionResponse])
async def list_permissions(hospital_id: int, db: AsyncSession = Depends(get_db)):
    return await get_permissions_for_hospital(db, hospital_id)

@router.post("/bulk", response_model=List[HospitalPermissionResponse])
async def add_permissions_bulk(hp: HospitalPermissionBulkCreate, db: AsyncSession = Depends(get_db)):
    return await add_permissions_to_hospital(db, hp)