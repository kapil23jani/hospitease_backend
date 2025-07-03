from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.nursing_note import NursingNoteCreate, NursingNoteUpdate, NursingNoteOut
from app.crud.nursing_note import (
    create_nursing_note, get_nursing_note, get_all_nursing_notes, update_nursing_note, delete_nursing_note, get_nursing_notes_by_admission_id
)

router = APIRouter(prefix="/nursing-notes", tags=["Nursing Notes"])

@router.post("/", response_model=NursingNoteOut)
async def create_nursing_note_route(note: NursingNoteCreate, db: AsyncSession = Depends(get_db)):
    return await create_nursing_note(db, note)

@router.get("/{note_id}", response_model=NursingNoteOut)
async def read_nursing_note(note_id: int, db: AsyncSession = Depends(get_db)):
    db_note = await get_nursing_note(db, note_id)
    if not db_note:
        raise HTTPException(status_code=404, detail="Nursing note not found")
    return db_note

@router.get("/", response_model=List[NursingNoteOut])
async def read_all_nursing_notes(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_all_nursing_notes(db, skip, limit)

@router.put("/{note_id}", response_model=NursingNoteOut)
async def update_nursing_note_route(note_id: int, note: NursingNoteUpdate, db: AsyncSession = Depends(get_db)):
    return await update_nursing_note(db, note_id, note)

@router.delete("/{note_id}")
async def delete_nursing_note_route(note_id: int, db: AsyncSession = Depends(get_db)):
    await delete_nursing_note(db, note_id)
    return {"ok": True}

@router.get("/by-admission/{admission_id}", response_model=List[NursingNoteOut])
async def fetch_nursing_notes_by_admission(
    admission_id: int,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db)
):
    notes = await get_nursing_notes_by_admission_id(db, admission_id, skip, limit)
    if not notes:
        raise HTTPException(status_code=404, detail="No nursing notes found for this admission")
    return notes