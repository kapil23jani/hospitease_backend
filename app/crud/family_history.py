from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from fastapi import HTTPException
from app.models.family_history import FamilyHistory
from app.schemas.family_history import FamilyHistoryCreate, FamilyHistoryUpdate

async def create_family_history(db: AsyncSession, data: FamilyHistoryCreate):
    new_entry = FamilyHistory(**data.dict())
    db.add(new_entry)
    await db.commit()
    await db.refresh(new_entry)
    return new_entry

async def get_family_history_by_appointment(db: AsyncSession, appointment_id: int):
    result = await db.execute(select(FamilyHistory).filter(FamilyHistory.appointment_id == appointment_id))
    return result.scalars().all()

async def update_family_history(db: AsyncSession, family_history_id: int, update_data: FamilyHistoryUpdate):
    result = await db.execute(select(FamilyHistory).filter(FamilyHistory.id == family_history_id))
    family_history = result.scalars().first()

    if not family_history:
        raise HTTPException(status_code=404, detail="Family history record not found")

    for key, value in update_data.dict(exclude_unset=True).items():
        setattr(family_history, key, value)

    await db.commit()
    await db.refresh(family_history)
    return family_history

async def delete_family_history(db: AsyncSession, family_history_id: int):
    result = await db.execute(select(FamilyHistory).filter(FamilyHistory.id == family_history_id))
    family_history = result.scalars().first()

    if not family_history:
        raise HTTPException(status_code=404, detail="Family history record not found")

    await db.delete(family_history)
    await db.commit()
    return {"message": "Family history record deleted successfully"}
