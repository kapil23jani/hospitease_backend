from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class AppointmentBase(BaseModel):
    patient_id: int
    doctor_id: int
    appointment_datetime: datetime  # No conversion
    problem: Optional[str] = None
    appointment_type: Optional[str] = None
    reason: Optional[str] = None

class AppointmentCreate(AppointmentBase):
    pass

class AppointmentUpdate(BaseModel):
    appointment_datetime: Optional[datetime] = None
    problem: Optional[str] = None
    appointment_type: Optional[str] = None
    reason: Optional[str] = None

class AppointmentResponse(AppointmentBase):
    id: int

    class Config:
        from_attributes = True  # Ensures correct datetime handling
