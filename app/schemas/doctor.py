from pydantic import BaseModel, EmailStr
from typing import Optional, List

class DoctorBase(BaseModel):
    first_name: str
    last_name: str
    specialization: str
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None
    experience: Optional[int] = None
    is_active: Optional[bool] = True
    hospital_id: int

class DoctorCreate(DoctorBase):
    pass

class DoctorUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    specialization: Optional[str] = None
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None
    experience: Optional[int] = None
    is_active: Optional[bool] = None

class DoctorResponse(DoctorBase):
    id: int

    class Config:
        orm_mode = True
