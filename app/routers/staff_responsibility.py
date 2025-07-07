from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.staff_responsibility import *
from app.crud import staff_responsibility as crud
from app.models.staff import Staff

router = APIRouter(prefix="/staff-responsibility", tags=["Staff Responsibility"])

@router.post("/", response_model=StaffResponsibilityResponse)
async def create_responsibility(data: StaffResponsibilityCreate, db: AsyncSession = Depends(get_db)):
    return await crud.create_responsibility(db, data.name, data.description)

@router.get("/", response_model=List[StaffResponsibilityResponse])
async def list_responsibilities(db: AsyncSession = Depends(get_db)):
    return await crud.list_responsibilities(db)

@router.post("/assign", response_model=StaffResponsibilityAssignmentResponse)
async def assign_responsibility(data: StaffResponsibilityAssignmentCreate, db: AsyncSession = Depends(get_db)):
    return await crud.assign_responsibility(db, data.staff_id, data.responsibility_id, data.assigned_by)

@router.post("/revoke/{assignment_id}")
async def revoke_responsibility(assignment_id: int, revoked_by: int, db: AsyncSession = Depends(get_db)):
    return await crud.revoke_responsibility(db, assignment_id, revoked_by)

@router.get("/staff/{staff_id}", response_model=List[StaffResponsibilityAssignmentResponse])
async def get_staff_assignments(staff_id: int, db: AsyncSession = Depends(get_db)):
    return await crud.get_staff_assignments(db, staff_id)

@router.get("/staff/{staff_id}", response_model=List[StaffResponsibilityAssignmentResponse])
async def list_staff_responsibilities(staff_id: int, db: AsyncSession = Depends(get_db)):
    return await get_staff_responsibility_assignments(db, staff_id)