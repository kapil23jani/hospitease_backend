from pydantic import BaseModel, EmailStr
from datetime import date
from typing import Optional

class PatientCreate(BaseModel):
  first_name: str
  middle_name: Optional[str] = None
  last_name: str
  date_of_birth: Optional[date] = None
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
  is_dialysis_patient: Optional[bool] = False
  # hospital_id: int
  # user_id: int

class PatientResponse(PatientCreate):
    id: int
    class Config:
        orm_mode = True