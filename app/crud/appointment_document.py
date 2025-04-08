from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.appointment_document import AppointmentDocument
from app.schemas.appointment_document import DocumentCreate, DocumentUpdate

async def create_document(db: AsyncSession, doc: DocumentCreate):
    new_doc = AppointmentDocument(**doc.dict())
    db.add(new_doc)
    await db.commit()
    await db.refresh(new_doc)
    return new_doc

async def get_document_by_id(db: AsyncSession, doc_id: int):
    query = select(AppointmentDocument).where(AppointmentDocument.id == doc_id)
    result = await db.execute(query)
    return result.scalars().first()

async def get_documents_by_appointment(db: AsyncSession, appointment_id: int):
    query = select(AppointmentDocument).where(
        AppointmentDocument.documentable_id == appointment_id,
        AppointmentDocument.documentable_type == "appointment"
    )
    result = await db.execute(query)
    return result.scalars().all()

async def update_document(db: AsyncSession, doc_id: int, doc_data: DocumentUpdate):
    query = select(AppointmentDocument).where(AppointmentDocument.id == doc_id)
    result = await db.execute(query)
    db_doc = result.scalars().first()

    if not db_doc:
        return None

    for key, value in doc_data.dict(exclude_unset=True).items():
        setattr(db_doc, key, value)

    db.add(db_doc)
    await db.commit()
    await db.refresh(db_doc)
    
    return db_doc

async def delete_document(db: AsyncSession, doc_id: int):
    query = select(AppointmentDocument).where(AppointmentDocument.id == doc_id)
    result = await db.execute(query)
    db_doc = result.scalars().first()

    if not db_doc:
        return None

    await db.delete(db_doc)
    await db.commit()
    return db_doc
