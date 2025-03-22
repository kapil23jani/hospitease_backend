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

class DoctorResponse(BaseModel):
    id: int
    first_name: str
    last_name: str
    full_name: str

    @classmethod
    def from_orm(cls, obj):
        return cls(
            id=obj.id,
            first_name=obj.first_name,
            last_name=obj.last_name,
            full_name=f"{obj.first_name} {obj.last_name}",
        )

class PatientResponse(BaseModel):
    id: int
    first_name: str
    last_name: str
    full_name: str

    @classmethod
    def from_orm(cls, obj):
        return cls(
            id=obj.id,
            first_name=obj.first_name,
            last_name=obj.last_name,
            full_name=f"{obj.first_name} {obj.last_name}",        )

class AppointmentListingResponse(BaseModel):
    id: int
    patient: PatientResponse
    doctor: DoctorResponse
    appointment_datetime: datetime
    problem: str
    appointment_type: str
    reason: Optional[str]
    
    class Config:
        from_attributes = True
