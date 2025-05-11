from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class SymptomBase(BaseModel):
    description: str
    duration: str
    severity: str
    onset: str
    contributing_factors: Optional[str] = None
    recurring: bool
    doctor_comment: Optional[str] = None
    doctor_suggestions: Optional[str] = None

class SymptomCreate(SymptomBase):
    appointment_id: int

class SymptomUpdate(BaseModel):
    description: Optional[str] = None
    duration: Optional[str] = None
    severity: Optional[str] = None
    onset: Optional[str] = None
    contributing_factors: Optional[str] = None
    recurring: Optional[bool] = None
    doctor_comment: Optional[str] = None
    doctor_suggestions: Optional[str] = None

class SymptomResponse(SymptomBase):
    id: int
    appointment_id: int

    class Config:
        from_attributes = True