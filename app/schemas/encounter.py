from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class EncounterBase(BaseModel):
    patient_id: str
    encounter_date: Optional[datetime]
    type: Optional[str]
    status: Optional[str]
    admission_date: Optional[datetime]
    discharge_date: Optional[datetime]
    notes: Optional[str]

class EncounterCreate(EncounterBase):
    pass

class EncounterUpdate(EncounterBase):
    pass

class EncounterResponse(EncounterBase):
    encounter_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True