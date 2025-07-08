from pydantic import BaseModel
from typing import Optional, Dict, Any
from datetime import datetime, date

class AdmissionDischargeBase(BaseModel):
    admission_id: int
    discharge_date: datetime
    discharge_type: str
    summary: Optional[str] = None
    follow_up_date: Optional[date] = None
    follow_up_instructions: Optional[str] = None
    attending_doctor: Optional[str] = None
    checklist: Optional[Dict[str, Any]] = None

class AdmissionDischargeCreate(AdmissionDischargeBase):
    pass

class AdmissionDischargeUpdate(AdmissionDischargeBase):
    pass

class AdmissionDischargeOut(AdmissionDischargeBase):
    id: int
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True