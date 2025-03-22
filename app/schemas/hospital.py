from pydantic import BaseModel, EmailStr
from typing import Optional, List
import datetime
from app.schemas.patient import PatientResponse
from app.schemas.user import UserResponse  

class HospitalBase(BaseModel):
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    zipcode: Optional[str] = None
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None
    admin_id: Optional[int] = None  
    licence_number: Optional[str] = None
    licence_authority: Optional[str] = None
    license_expiry_date: Optional[datetime.date] = None

    title: Optional[str] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    gender: Optional[str] = None
    date_of_birth: Optional[datetime.date] = None
    blood_group: Optional[str] = None
    mobile_number: Optional[str] = None
    emergency_contact: Optional[str] = None
    specialization: Optional[str] = None
    experience: Optional[int] = None
    medical_licence_number: Optional[str] = None

class HospitalCreate(HospitalBase):
    pass

class HospitalUpdate(HospitalBase):
    pass

class HospitalResponse(HospitalBase):
    id: int
    # admin: Optional[UserResponse] = None
    # patients: List[PatientResponse] = []

    class Config:
        from_attributes = True  
