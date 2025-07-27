from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.appointment_document import AppointmentDocument
from app.schemas.appointment_document import DocumentCreate, DocumentUpdate
from app.utils.s3 import upload_file_to_s3, get_presigned_url
from io import BytesIO
from fastapi import UploadFile, File, Depends, Form
from app.database import get_db
from datetime import datetime

async def create_document(db: AsyncSession, doc: DocumentCreate, file_obj=None, filename=None):
    s3_url = None
    if file_obj and filename:
        s3_url = upload_file_to_s3(BytesIO(file_obj), filename, folder="appointment_docs")
    doc_data = doc.dict()
    if s3_url:
        doc_data["file_url"] = s3_url
    new_doc = AppointmentDocument(**doc_data)
    db.add(new_doc)
    await db.commit()
    await db.refresh(new_doc)
    return new_doc

async def get_document_by_id(db: AsyncSession, doc_id: int):
    query = select(AppointmentDocument).where(AppointmentDocument.id == doc_id)
    result = await db.execute(query)
    doc = result.scalars().first()
    if doc and doc.file_url:
        doc.file_url = get_presigned_url(doc.file_url)
    return doc

async def get_documents_by_appointment(db: AsyncSession, appointment_id: int):
    query = select(AppointmentDocument).where(
        AppointmentDocument.documentable_id == appointment_id,
        AppointmentDocument.documentable_type == "appointment"
    )
    result = await db.execute(query)
    docs = result.scalars().all()
    for doc in docs:
        if doc.file_url:
            doc.file_url = get_presigned_url(doc.file_url)
    return docs

async def update_document(db: AsyncSession, doc_id: int, doc_data: DocumentUpdate, file_obj=None, filename=None):
    query = select(AppointmentDocument).where(AppointmentDocument.id == doc_id)
    result = await db.execute(query)
    db_doc = result.scalars().first()

    if not db_doc:
        return None

    # Upload new file to S3 if provided
    if file_obj and filename:
        s3_url = upload_file_to_s3(BytesIO(file_obj), filename, folder="appointment_docs")
        doc_data.file_url = s3_url

    # Update fields from doc_data
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