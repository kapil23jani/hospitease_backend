from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.ext.asyncio import AsyncSession

from app.crud.role import create_role, get_role, delete_role, update_role, get_roles
from app.schemas import RoleResponse, RoleUpdate, RoleCreate, RoleBase

from app.database import get_db

router = APIRouter()

@router.post("/", response_model=RoleResponse)
async def r_create_role(role: RoleCreate, db: Session = Depends(get_db)):
    return await create_role(db, role)

@router.get("/{role_id}", response_model=RoleResponse)
async def r_get_role(role_id: int, db: Session = Depends(get_db)):
    role = get_role(db=db, role_id=role_id)
    if role is None:
        raise HTTPException(status_code=404, detail="Role not found")
    return await role

@router.get("/", response_model=list[RoleResponse])
async def r_get_roles(skip: int = 0, limit: int = 10, db: AsyncSession = Depends(get_db)):
    return await get_roles(db=db, skip=skip, limit=limit)

@router.put("/{role_id}", response_model=RoleResponse)
async def r_update_role(role_id: int, role_data: RoleUpdate, db: Session = Depends(get_db)):
    role = update_role(db=db, role_id=role_id, role_data=role_data)
    if role is None:
        raise HTTPException(status_code=404, detail="Role not found")
    return await role

@router.delete("/{role_id}")
async def r_delete_role(role_id: int, db: Session = Depends(get_db)):
    role = delete_role(db=db, role_id=role_id)
    if role is None:
        raise HTTPException(status_code=404, detail="Role not found")
    return await {"message": "Role deleted successfully"}
