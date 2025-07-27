from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.appointment_document import DocumentCreate, DocumentUpdate, DocumentResponse
from app.crud.appointment_document import (
    create_document, get_document_by_id, get_documents_by_appointment, update_document, delete_document
)

router = APIRouter()

@router.post("/", response_model=DocumentResponse)
async def add_document(
    document_name: str = Form(...),
    document_type: str = Form(...),
    size: int = Form(...),
    status: str = Form(...),
    documentable_type: str = Form(...),
    documentable_id: int = Form(...),
    file: UploadFile = File(None),
    db: AsyncSession = Depends(get_db)
):
    from datetime import datetime
    doc = DocumentCreate(
        document_name=document_name,
        document_type=document_type,
        size=size,
        status=status,
        documentable_type=documentable_type,
        documentable_id=documentable_id
    )
    file_obj = await file.read() if file else None
    filename = file.filename if file else None
    return await create_document(db, doc, file_obj=file_obj, filename=filename)

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
async def modify_document(
    doc_id: int,
    document_name: str = Form(None),
    document_type: str = Form(None),
    size: int = Form(None),
    status: str = Form(None),
    documentable_type: str = Form(None),
    documentable_id: int = Form(None),
    file: UploadFile = File(None),
    db: AsyncSession = Depends(get_db)
):
    from datetime import datetime
    doc_update = DocumentUpdate(
        document_name=document_name,
        document_type=document_type,
        size=size,
        status=status,
        documentable_type=documentable_type,
        documentable_id=documentable_id
    )
    file_obj = await file.read() if file else None
    filename = file.filename if file else None
    updated_doc = await update_document(db, doc_id, doc_update, file_obj=file_obj, filename=filename)
    if not updated_doc:
        raise HTTPException(status_code=404, detail="Document not found")
    return updated_doc

@router.delete("/{doc_id}")
async def remove_document(doc_id: int, db: AsyncSession = Depends(get_db)):
    deleted_doc = await delete_document(db, doc_id)
    if not deleted_doc:
        raise HTTPException(status_code=404, detail="Document not found")
    return {"message": "Document deleted successfully"}
