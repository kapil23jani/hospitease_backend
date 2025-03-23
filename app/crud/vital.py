from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.models import Vital
from app.schemas.vital import VitalCreate

async def create_vital(db: AsyncSession, vital_data: VitalCreate):
    """Create a new vital record."""
    new_vital = Vital(**vital_data.model_dump())
    db.add(new_vital)
    await db.commit()
    await db.refresh(new_vital)
    return new_vital

async def get_vitals_by_appointment(db: AsyncSession, appointment_id: int):
    """Retrieve vitals linked to a specific appointment."""
    query = select(Vital).where(Vital.appointment_id == appointment_id)
    result = await db.execute(query)
    return result.scalars().all()

async def get_vital_by_id(db: AsyncSession, vital_id: int):
    """Retrieve a single vital record by ID."""
    query = select(Vital).where(Vital.id == vital_id)
    result = await db.execute(query)
    return result.scalars().first()

async def update_vital(db: AsyncSession, vital_id: int, vital_data: VitalCreate):
    """Update an existing vital record."""
    query = select(Vital).where(Vital.id == vital_id)
    result = await db.execute(query)
    db_vital = result.scalars().first()

    if not db_vital:
        return None

    for key, value in vital_data.model_dump(exclude_unset=True).items():
        setattr(db_vital, key, value)

    await db.commit()
    await db.refresh(db_vital)
    return db_vital

async def delete_vital(db: AsyncSession, vital_id: int):
    """Delete a vital record by ID."""
    query = select(Vital).where(Vital.id == vital_id)
    result = await db.execute(query)
    db_vital = result.scalars().first()

    if db_vital:
        await db.delete(db_vital)
        await db.commit()
    
    return db_vital
