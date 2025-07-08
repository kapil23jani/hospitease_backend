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
    time_interval: Optional[str] = None
    route: Optional[str] = None
    quantity: Optional[str] = None
    route: Optional[str] = None
    instruction: Optional[str] = None
class MedicineCreate(MedicineBase):
    pass
class MedicineUpdate(BaseModel):
    name: Optional[str] = None
    dosage: Optional[str] = None
    frequency: Optional[str] = None
    duration: Optional[str] = None
    start_date: Optional[str] = None
    status: Optional[str] = None
    time_interval: Optional[str] = "N/A"
    route: Optional[str] = "N/A"
    quantity: Optional[str] = "N/A"
    route: Optional[str] = "N/A"
    instruction: Optional[str] = "N/A"
class MedicineOut(MedicineBase):
    id: int
    class Config:
        from_attributes = True
