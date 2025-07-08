from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from datetime import datetime

class Meal(BaseModel):
    name: str
    time: str  # e.g. "08:00"
    items: List[str]
    notes: Optional[str] = None

class AdmissionDietBase(BaseModel):
    admission_id: int
    diet_type: str
    is_veg: bool
    allergies: Optional[List[str]] = None
    meals: List[Meal]
    notes: Optional[str] = None

class AdmissionDietCreate(AdmissionDietBase):
    pass

class AdmissionDietUpdate(AdmissionDietBase):
    pass

class AdmissionDietOut(AdmissionDietBase):
    id: int
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True