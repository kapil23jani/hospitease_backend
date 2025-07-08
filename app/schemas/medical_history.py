from pydantic import BaseModel
from typing import Optional
from datetime import date

class MedicalHistoryBase(BaseModel):
    condition: str
    diagnosis_date: Optional[date] = None
    treatment: Optional[str] = None
    doctor: Optional[str] = None
    hospital: Optional[str] = None
    status: Optional[str] = None

class MedicalHistoryCreate(MedicalHistoryBase):
    patient_id: int

class MedicalHistoryUpdate(MedicalHistoryBase):
    pass

class MedicalHistory(MedicalHistoryBase):
    id: int
    patient_id: int

    class Config:
        from_attributes = True
