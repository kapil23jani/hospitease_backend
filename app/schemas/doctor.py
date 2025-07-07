from pydantic import BaseModel, EmailStr
from typing import Optional, List, Dict
import datetime
from datetime import date
class HospitalBase(BaseModel):
    name: Optional[str] = None
    registration_number: Optional[str] = None
    type: Optional[str] = None
    logo_url: Optional[str] = None
    website: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    zipcode: Optional[str] = None
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None
    admin_id: Optional[int] = None
    owner_name: Optional[str] = None
    admin_contact_number: Optional[str] = None
    number_of_beds: Optional[int] = True
    departments: Optional[List[str]] = None
    specialties: Optional[List[str]] = None
    facilities: Optional[List[str]] = None
    ambulance_services: Optional[bool] = None
    opening_hours: Optional[Dict[str, str]] = None
    license_number: Optional[str] = None
    license_expiry_date: Optional[datetime.date] = None
    is_accredited: Optional[bool] = None
    external_id: Optional[str] = None
    timezone: Optional[str] = None
    is_active: Optional[bool] = True
class HospitalCreate(HospitalBase):
    pass
class HospitalUpdate(HospitalBase):
    pass
class HospitalResponse(HospitalBase):
    id: int
    created_at: Optional[datetime.datetime] = None
    updated_at: Optional[datetime.datetime] = None
    class Config:
        orm_mode = True
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
    password: str
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
    hospital: HospitalResponse

    class Config:
        orm_mode = True
