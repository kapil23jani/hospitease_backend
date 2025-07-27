from pydantic import BaseModel, EmailStr
from typing import Optional, List, Dict
import datetime
from app.schemas.permission import PermissionResponse
from app.schemas.hospital_payment import HospitalPaymentResponse

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
    number_of_beds: Optional[int] = None
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
    permissions: List[PermissionResponse] = []
    hospital_payments: List[HospitalPaymentResponse] = []
    presigned_logo_url: Optional[str] = None

    class Config:
        orm_mode = True