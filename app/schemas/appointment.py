from pydantic import BaseModel
from datetime import datetime
from typing import Optional


# Base schema for Appointment (this will be inherited)
class AppointmentBase(BaseModel):
    patient_id: int
    doctor_id: int
    appointment_datetime: datetime  # No conversion
    problem: Optional[str] = None
    appointment_type: Optional[str] = None
    reason: Optional[str] = None

    # Optional fields for other appointment details
    blood_pressure: Optional[str] = None
    pulse_rate: Optional[str] = None
    temperature: Optional[str] = None
    spo2: Optional[str] = None
    weight: Optional[str] = None
    additional_notes: Optional[str] = None
    advice: Optional[str] = None
    follow_up_date: Optional[datetime] = None
    follow_up_notes: Optional[str] = None


# Schema for creating an appointment
class AppointmentCreate(AppointmentBase):
    pass


# Schema for updating an appointment
class AppointmentUpdate(BaseModel):
    appointment_datetime: Optional[datetime] = None
    problem: Optional[str] = None
    appointment_type: Optional[str] = None
    reason: Optional[str] = None

    blood_pressure: Optional[str] = None
    pulse_rate: Optional[str] = None
    temperature: Optional[str] = None
    spo2: Optional[str] = None
    weight: Optional[str] = None
    additional_notes: Optional[str] = None
    advice: Optional[str] = None
    follow_up_date: Optional[datetime] = None
    follow_up_notes: Optional[str] = None


# Schema for detailed response of an appointment
class AppointmentResponse(AppointmentBase):
    id: int

    class Config:
        from_attributes = True  # Ensures correct datetime handling


# Schema for Doctor response
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


# Schema for Patient response
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
            full_name=f"{obj.first_name} {obj.last_name}",
        )


# Schema for listing appointments, now including patient and doctor info
class AppointmentListingResponse(BaseModel):
    id: int
    patient: PatientResponse  # Include PatientResponse for patient info
    doctor: DoctorResponse  # Include DoctorResponse for doctor info
    appointment_datetime: datetime
    problem: Optional[str]
    appointment_type: Optional[str]
    reason: Optional[str]

    class Config:
        from_attributes = True  # Ensures correct datetime handling
