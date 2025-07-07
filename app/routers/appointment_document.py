from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.appointment_document import DocumentCreate, DocumentUpdate, DocumentResponse
from app.crud.appointment_document import (
    create_document, get_document_by_id, get_documents_by_appointment, update_document, delete_document
)

router = APIRouter()

@router.post("/", response_model=DocumentResponse)
async def add_document(doc: DocumentCreate, db: AsyncSession = Depends(get_db)):
    return await create_document(db, doc)

@router.get("/{doc_id}", response_model=DocumentResponse)
async def fetch_document(doc_id: int, db: AsyncSession = Depends(get_db)):
    doc = await get_document_by_id(db, doc_id)
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")
    return doc

@router.get("/appointment/{appointment_id}", response_model=list[DocumentResponse])
async def fetch_appointment_documents(appointment_id: int, db: AsyncSession = Depends(get_db)):
    return await get_documents_by_appointment(db, appointment_id)

@router.put("/{doc_id}", response_model=DocumentResponse)
async def modify_document(doc_id: int, doc: DocumentUpdate, db: AsyncSession = Depends(get_db)):
    updated_doc = await update_document(db, doc_id, doc)
    if not updated_doc:
        raise HTTPException(status_code=404, detail="Document not found")
    return updated_doc

@router.delete("/{doc_id}")
async def remove_document(doc_id: int, db: AsyncSession = Depends(get_db)):
    deleted_doc = await delete_document(db, doc_id)
    if not deleted_doc:
        raise HTTPException(status_code=404, detail="Document not found")
    return {"message": "Document deleted successfully"}
