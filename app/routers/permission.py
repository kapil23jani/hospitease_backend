from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.schemas.permission import PermissionCreate, PermissionUpdate, PermissionResponse
from app.crud.permission import (
    create_permission, get_permission, get_permissions, update_permission, delete_permission
)
from app.database import get_db

router = APIRouter(prefix="", tags=["permissions"])

@router.post("/", response_model=PermissionResponse)
async def create_permission_api(permission: PermissionCreate, db: AsyncSession = Depends(get_db)):
    return await create_permission(db, permission)

@router.get("/", response_model=List[PermissionResponse])
async def list_permissions(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_permissions(db, skip=skip, limit=limit)

@router.get("/{permission_id}", response_model=PermissionResponse)
async def get_permission_api(permission_id: int, db: AsyncSession = Depends(get_db)):
    permission = await get_permission(db, permission_id)
    if not permission:
        raise HTTPException(status_code=404, detail="Permission not found")
    return permission

@router.put("/{permission_id}", response_model=PermissionResponse)
async def update_permission_api(permission_id: int, permission: PermissionUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_permission(db, permission_id, permission)
    if not updated:
        raise HTTPException(status_code=404, detail="Permission not found")
    return updated

@router.delete("/{permission_id}", response_model=PermissionResponse)
async def delete_permission_api(permission_id: int, db: AsyncSession = Depends(get_db)):
    deleted = await delete_permission(db, permission_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Permission not found")
    return deleted