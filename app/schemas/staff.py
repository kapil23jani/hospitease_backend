from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime

# Minimal Hospital and User schemas for embedding
class HospitalOut(BaseModel):
    id: int
    name: Optional[str] = None  # Add more fields as needed

    class Config:
        from_attributes = True

class UserOut(BaseModel):
    id: int
    email: Optional[str] = None  # Add more fields as needed

    class Config:
        from_attributes = True

class StaffBase(BaseModel):
    hospital_id: int
    user_id: int
    first_name: str
    last_name: str
    title: Optional[str] = None
    gender: Optional[str] = None
    date_of_birth: Optional[date] = None
    phone_number: Optional[str] = None
    email: Optional[str] = None
    role: str
    department: Optional[str] = None
    specialization: Optional[str] = None
    qualification: Optional[str] = None
    experience: Optional[int] = None
    joining_date: Optional[date] = None
    is_active: Optional[bool] = True
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    zipcode: Optional[str] = None
    emergency_contact: Optional[str] = None
    photo_url: Optional[str] = None

class StaffCreate(StaffBase):
    password: str  # Add password field for creation

class StaffUpdate(StaffBase):
    password: Optional[str] = None  # Optional for update

class StaffOut(StaffBase):
    id: int
    created_at: Optional[datetime]
    updated_at: Optional[datetime]
    hospital: Optional[HospitalOut] = None
    user: Optional[UserOut] = None

    class Config:
        from_attributes = True