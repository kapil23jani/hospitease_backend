from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.encounter import EncounterCreate, EncounterUpdate, EncounterResponse
from app.crud.encounter import get_encounters, get_encounter, create_encounter, update_encounter, delete_encounter

router = APIRouter(prefix="/encounters", tags=["Encounters"])

@router.get("/", response_model=List[EncounterResponse])
async def list_encounters(db: AsyncSession = Depends(get_db)):
    return await get_encounters(db)

@router.get("/{encounter_id}", response_model=EncounterResponse)
async def read_encounter(encounter_id: str, db: AsyncSession = Depends(get_db)):
    encounter = await get_encounter(db, encounter_id)
    if not encounter:
        raise HTTPException(status_code=404, detail="Encounter not found")
    return encounter

@router.post("/", response_model=EncounterResponse)
async def create_new_encounter(encounter: EncounterCreate, db: AsyncSession = Depends(get_db)):
    return await create_encounter(db, encounter)

@router.put("/{encounter_id}", response_model=EncounterResponse)
async def update_existing_encounter(encounter_id: str, encounter: EncounterUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_encounter(db, encounter_id, encounter)
    if not updated:
        raise HTTPException(status_code=404, detail="Encounter not found")
    return updated

@router.delete("/{encounter_id}")
async def delete_existing_encounter(encounter_id: str, db: AsyncSession = Depends(get_db)):
    deleted = await delete_encounter(db, encounter_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Encounter not found")
    return {"ok": True}