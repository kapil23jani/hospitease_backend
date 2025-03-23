from pydantic import BaseModel
from typing import Optional

class MedicineBase(BaseModel):
    appointment_id: int
    name: str
    dosage: str
    frequency: str
    duration: str
    start_date: str
    status: str

class MedicineCreate(MedicineBase):
    pass

class MedicineUpdate(BaseModel):
    name: Optional[str] = None
    dosage: Optional[str] = None
    frequency: Optional[str] = None
    duration: Optional[str] = None
    start_date: Optional[str] = None
    status: Optional[str] = None

class MedicineOut(MedicineBase):
    id: int

    class Config:
        orm_mode = True
