from pydantic import BaseModel, EmailStr
from typing import Optional, List
from app.schemas.patient import PatientResponse
from app.schemas.user import UserResponse  # ✅ Import User schema

class HospitalBase(BaseModel):
    name: str
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None
    admin_id: Optional[int] = None  # ✅ Updated field

class HospitalCreate(HospitalBase):
    pass

class HospitalUpdate(HospitalBase):
    pass

class HospitalResponse(HospitalBase):
    id: int
    # admin: Optional[UserResponse] = None
    # patients: List[PatientResponse] = []

    class Config:
        from_attributes = True  # ✅ Use this instead of orm_mode
