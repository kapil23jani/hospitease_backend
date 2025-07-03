from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List


# Base schema for Appointment (this will be inherited)
class AppointmentBase(BaseModel):
    patient_id: int
    doctor_id: int
    hospital_id: int
    appointment_datetime: Optional[str] = None  # No conversion
    problem: Optional[str] = None
    appointment_type: Optional[str] = None
    reason: Optional[str] = None
    appointment_unique_id: Optional[str] = None
    # Optional fields for other appointment details
    blood_pressure: Optional[str] = None
    pulse_rate: Optional[str] = None
    temperature: Optional[str] = None
    spo2: Optional[str] = None
    weight: Optional[str] = None
    additional_notes: Optional[str] = None
    advice: Optional[str] = None
    follow_up_date: Optional[str] = None
    follow_up_notes: Optional[str] = None
    appointment_date: Optional[str] = None
    appointment_time: Optional[str] = None
    status: Optional[str] = None
    mode_of_appointment: Optional[str] = None  # <-- Add this line


# Schema for creating an appointment
class AppointmentCreate(AppointmentBase):
    pass


# Schema for updating an appointment
class AppointmentUpdate(BaseModel):
    appointment_datetime: Optional[str] = None
    problem: Optional[str] = None
    appointment_type: Optional[str] = None
    reason: Optional[str] = None
    appointment_date: Optional[str] = None
    appointment_time: Optional[str] = None
    blood_pressure: Optional[str] = None
    pulse_rate: Optional[str] = None
    temperature: Optional[str] = None
    spo2: Optional[str] = None
    weight: Optional[str] = None
    additional_notes: Optional[str] = None
    advice: Optional[str] = None
    follow_up_date: Optional[str] = None
    follow_up_notes: Optional[str] = None
    appointment_date: Optional[str] = None
    appointment_time: Optional[str] = None
    status: Optional[str] = None


# Schema for detailed response of an appointment
class AppointmentResponse(AppointmentBase):
    id: int

    class Config:
        from_attributes = True


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


class AppointmentListingResponse(BaseModel):
    id: int
    appointment_unique_id: str  # <-- Add this line
    patient: PatientResponse
    doctor: DoctorResponse
    problem: Optional[str]
    appointment_type: Optional[str]
    reason: Optional[str]
    appointment_date: Optional[str]
    appointment_time: Optional[str]
    status: Optional[str]
    class Config:
        from_attributes = True


class Medicine(BaseModel):
    name: str
    dose: str
    frequency: str
    duration: str


class PrescriptionResponse(BaseModel):
    complaint: str
    diagnosis: str
    medicines: List[Medicine]
