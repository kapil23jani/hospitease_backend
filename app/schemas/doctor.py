from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import date

class DoctorBase(BaseModel):
    title: Optional[str] = None
    first_name: str
    last_name: str
    gender: Optional[str] = None
    date_of_birth: Optional[date] = None
    blood_group: Optional[str] = None
    mobile_number: Optional[str] = None
    emergency_contact: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    zipcode: Optional[str] = None
    specialization: str
    experience: Optional[int] = None
    medical_licence_number: Optional[str] = None
    licence_authority: Optional[str] = None
    license_expiry_date: Optional[date] = None
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None
    is_active: Optional[bool] = True
    hospital_id: int
    user_id: Optional[int] = None

class DoctorCreate(DoctorBase):
    password: str  # Required for user creation

class DoctorUpdate(BaseModel):
    title: Optional[str] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    gender: Optional[str] = None
    date_of_birth: Optional[date] = None
    blood_group: Optional[str] = None
    mobile_number: Optional[str] = None
    emergency_contact: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    zipcode: Optional[str] = None
    specialization: Optional[str] = None
    experience: Optional[int] = None
    medical_licence_number: Optional[str] = None
    licence_authority: Optional[str] = None
    license_expiry_date: Optional[date] = None
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None
    is_active: Optional[bool] = None
    user_id: Optional[int] = None

class DoctorResponse(DoctorBase):
    id: int

    class Config:
        orm_mode = True
