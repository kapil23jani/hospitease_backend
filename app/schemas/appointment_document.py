from pydantic import BaseModel
from typing import Optional

class DocumentCreate(BaseModel):
    document_name: str
    document_type: str
    size: int
    status: str
    documentable_type: str
    documentable_id: int

class DocumentUpdate(BaseModel):
    document_name: Optional[str] = None
    document_type: Optional[str] = None
    size: Optional[int] = None
    status: Optional[str] = None
    documentable_type: Optional[str] = None
    documentable_id: Optional[int] = None
    file_url: Optional[str] = None  # Add this if you want to update file_url

class DocumentResponse(DocumentCreate):
    id: int
    file_url: Optional[str] = None  # <-- Add this line

    class Config:
        from_attributes = True
