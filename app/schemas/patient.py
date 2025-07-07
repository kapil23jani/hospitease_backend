from pydantic import BaseModel, EmailStr
from typing import Optional, List

class PatientBase(BaseModel):
    first_name: str
    middle_name: Optional[str] = None
    last_name: str
    date_of_birth: Optional[str] = None
    gender: str
    phone_number: Optional[str] = None
    landline: Optional[str] = None
    address: Optional[str] = None
    landmark: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    blood_group: Optional[str] = None
    email: Optional[EmailStr] = None
    occupation: Optional[str] = None
    is_dialysis_patient: bool = False
    marital_status: Optional[str] = None
    zipcode: Optional[str] = None
    hospital_id: int
    patient_unique_id:  Optional[str] = None
    mrd_number: Optional[str] = None


class PatientCreate(PatientBase):
    pass

class PatientUpdate(PatientBase):
    pass

class PatientResponse(PatientBase):
    id: int
    mrd_number: Optional[int] = None

    class Config:
        from_attributes = True  # for Pydantic v2
class PatientBasicResponse(BaseModel):
    id: int
    uniqueId: str
    name: str
    phone: Optional[str]
    age: Optional[int]
    gender: str