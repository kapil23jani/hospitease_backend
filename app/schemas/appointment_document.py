from pydantic import BaseModel
from typing import Optional

class DocumentCreate(BaseModel):
    document_name: str
    document_type: str
    upload_date: str
    size: str
    status: str
    documentable_id: int
    documentable_type: str

class DocumentUpdate(BaseModel):
    document_name: Optional[str] = None
    document_type: Optional[str] = None
    upload_date: Optional[str] = None
    size: Optional[str] = None
    status: Optional[str] = None

class DocumentResponse(DocumentCreate):
    id: int

    class Config:
        from_attributes = True
