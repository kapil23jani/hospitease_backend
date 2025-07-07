from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from app.models.staff_responsibility import StaffResponsibility, StaffResponsibilityAssignment
from fastapi import APIRouter, Depends
from app.database import get_db

router = APIRouter()

async def create_responsibility(db: AsyncSession, name: str, description: str = None):
    resp = StaffResponsibility(name=name, description=description)
    db.add(resp)
    await db.commit()
    await db.refresh(resp)
    return resp

async def list_responsibilities(db: AsyncSession):
    result = await db.execute(select(StaffResponsibility))
    return result.scalars().all()

async def assign_responsibility(db: AsyncSession, staff_id: str, responsibility_id: int, assigned_by: int):
    assignment = StaffResponsibilityAssignment(
        staff_id=staff_id,
        responsibility_id=responsibility_id,
        assigned_by=assigned_by
    )
    db.add(assignment)
    await db.commit()
    await db.refresh(assignment)
    return assignment

async def revoke_responsibility(db: AsyncSession, assignment_id: int, revoked_by: int):
    result = await db.execute(
        select(StaffResponsibilityAssignment).where(StaffResponsibilityAssignment.id == assignment_id)
    )
    assignment = result.scalar_one_or_none()
    if assignment:
        await db.delete(assignment)
        await db.commit()
    return assignment

async def get_staff_assignments(db: AsyncSession, staff_id: int):
    result = await db.execute(
        select(StaffResponsibilityAssignment).where(StaffResponsibilityAssignment.staff_id == staff_id)
    )
    return result.scalars().all()

async def get_staff_responsibility_assignments(db, staff_id):
    result = await db.execute(
        select(StaffResponsibilityAssignment)
        .options(selectinload(StaffResponsibilityAssignment.responsibility))
        .where(StaffResponsibilityAssignment.staff_id == staff_id)
    )
    assignments = result.scalars().all()
    return assignments