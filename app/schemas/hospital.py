from pydantic import BaseModel, EmailStr
from typing import Optional, List
from app.schemas.patient import PatientResponse

class HospitalBase(BaseModel):
    name: str
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None

class HospitalCreate(HospitalBase):
    pass

class HospitalUpdate(HospitalBase):
    pass

class HospitalResponse(HospitalBase):
    id: int
    # patients: List[PatientResponse] = []

    class Config:
        from_attributes = True  # ✅ Use this instead of orm_mode
