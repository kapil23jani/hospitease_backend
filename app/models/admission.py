from sqlalchemy import Column, Integer, String, Boolean, Date, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base

class Admission(Base):
    __tablename__ = "admissions"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"), nullable=False)
    appointment_id = Column(Integer, ForeignKey("appointments.id"), nullable=True)
    doctor_id = Column(Integer, ForeignKey("doctors.id"), nullable=False)
    admission_date = Column(Date, nullable=False)
    reason = Column(Text, nullable=True)
    status = Column(String(50), nullable=False, default="admitted")  # e.g. admitted, discharged, transferred
    bed_id = Column(Integer, ForeignKey("beds.id"), nullable=True)
    discharge_date = Column(Date, nullable=True)
    critical_care_required = Column(Boolean, default=False)
    care_24x7_required = Column(Boolean, default=False)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    patient = relationship("Patient")
    appointment = relationship("Appointment")
    doctor = relationship("Doctor")
    bed = relationship("Bed")
    vitals = relationship("AdmissionVital", back_populates="admission")
    medicines = relationship("AdmissionMedicine", back_populates="admission")
    nursing_notes = relationship("NursingNote", back_populates="admission")
    tests = relationship("AdmissionTest", back_populates="admission")
    diets = relationship("AdmissionDiet", back_populates="admission")