from pydantic import BaseModel
from typing import Optional
from datetime import date

class AdmissionMedicineBase(BaseModel):
    admission_id: int
    medicine_name: str
    dosage: Optional[str] = None
    frequency: Optional[str] = None
    duration: Optional[str] = None
    route: Optional[str] = None
    status: Optional[str] = "active"
    prescribed_by: Optional[str] = None
    prescribed_on: Optional[date] = None
    prescribed_till: Optional[date] = None
    notes: Optional[str] = None

class AdmissionMedicineCreate(AdmissionMedicineBase):
    pass

class AdmissionMedicineUpdate(AdmissionMedicineBase):
    pass

class AdmissionMedicineOut(AdmissionMedicineBase):
    id: int

    class Config:
        orm_mode = True