from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class AdmissionVitalBase(BaseModel):
    admission_id: int
    temperature: Optional[float] = None
    pulse: Optional[int] = None
    blood_pressure: Optional[str] = None
    spo2: Optional[int] = None
    notes: Optional[str] = None
    recorded_at: Optional[datetime] = None
    captured_by: Optional[str] = None

class AdmissionVitalCreate(AdmissionVitalBase):
    pass

class AdmissionVitalUpdate(AdmissionVitalBase):
    pass

class AdmissionVitalOut(AdmissionVitalBase):
    id: int

    class Config:
        orm_mode = True