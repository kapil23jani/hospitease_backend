from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from app.models.nursing_note import NursingNote
from app.schemas.nursing_note import NursingNoteCreate, NursingNoteUpdate

async def create_nursing_note(db: AsyncSession, note: NursingNoteCreate):
    db_note = NursingNote(**note.dict())
    db.add(db_note)
    await db.commit()
    await db.refresh(db_note)
    return db_note

async def get_nursing_note(db: AsyncSession, note_id: int):
    result = await db.execute(select(NursingNote).where(NursingNote.id == note_id))
    return result.scalar_one_or_none()

async def get_all_nursing_notes(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(NursingNote).offset(skip).limit(limit))
    return result.scalars().all()

async def update_nursing_note(db: AsyncSession, note_id: int, note: NursingNoteUpdate):
    await db.execute(
        update(NursingNote).where(NursingNote.id == note_id).values(**note.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_nursing_note(db, note_id)

async def delete_nursing_note(db: AsyncSession, note_id: int):
    await db.execute(delete(NursingNote).where(NursingNote.id == note_id))
    await db.commit()

async def get_nursing_notes_by_admission_id(db: AsyncSession, admission_id: int, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(NursingNote).where(NursingNote.admission_id == admission_id).offset(skip).limit(limit)
    )
    return result.scalars().all()