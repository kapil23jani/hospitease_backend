from pydantic import BaseModel
from typing import Optional

class FamilyHistoryBase(BaseModel):
    appointment_id: int
    relationship_to_you: str
    additional_notes: Optional[str] = None

class FamilyHistoryCreate(FamilyHistoryBase):
    pass

class FamilyHistoryUpdate(BaseModel):
    relationship_to_you: Optional[str] = None
    additional_notes: Optional[str] = None

class FamilyHistoryResponse(FamilyHistoryBase):
    id: int

    class Config:
        from_attributes = True
