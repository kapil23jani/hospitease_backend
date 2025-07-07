from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.encounter import Encounter
from app.schemas.encounter import EncounterCreate, EncounterUpdate

async def get_encounters(db: AsyncSession):
    result = await db.execute(select(Encounter))
    return result.scalars().all()

async def get_encounter(db: AsyncSession, encounter_id: str):
    result = await db.execute(select(Encounter).filter(Encounter.encounter_id == encounter_id))
    return result.scalar_one_or_none()

async def create_encounter(db: AsyncSession, encounter: EncounterCreate):
    db_encounter = Encounter(**encounter.model_dump())
    db.add(db_encounter)
    await db.commit()
    await db.refresh(db_encounter)
    return db_encounter

async def update_encounter(db: AsyncSession, encounter_id: str, encounter: EncounterUpdate):
    db_encounter = await get_encounter(db, encounter_id)
    if not db_encounter:
        return None
    for key, value in encounter.model_dump(exclude_unset=True).items():
        setattr(db_encounter, key, value)
    await db.commit()
    await db.refresh(db_encounter)
    return db_encounter

async def delete_encounter(db: AsyncSession, encounter_id: str):
    db_encounter = await get_encounter(db, encounter_id)
    if not db_encounter:
        return None
    await db.delete(db_encounter)
    await db.commit()
    return True