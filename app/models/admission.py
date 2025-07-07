from sqlalchemy import Column, Integer, String, Boolean, Date, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
from app.models.admission_discharge import AdmissionDischarge  # Make sure this import is correct

class Admission(Base):
    __tablename__ = "admissions"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"), nullable=False)
    appointment_id = Column(Integer, ForeignKey("appointments.id"), nullable=True)
    doctor_id = Column(Integer, ForeignKey("doctors.id"), nullable=False)
    hospital_id = Column(Integer, ForeignKey("hospitals.id"), nullable=False)  # <-- add this line
    admission_date = Column(Date, nullable=False)
    reason = Column(Text, nullable=True)
    status = Column(String(50), nullable=False, default="admitted")
    bed_id = Column(Integer, ForeignKey("beds.id"), nullable=True)
    discharge_date = Column(Date, nullable=True)
    critical_care_required = Column(Boolean, default=False)
    care_24x7_required = Column(Boolean, default=False)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    patient = relationship("Patient", lazy="selectin")
    appointment = relationship("Appointment", lazy="selectin")
    doctor = relationship("Doctor", lazy="selectin")
    hospital = relationship("Hospital", lazy="selectin")
    bed = relationship("Bed", lazy="selectin")
    vitals = relationship("AdmissionVital", back_populates="admission", lazy="selectin")
    medicines = relationship("AdmissionMedicine", back_populates="admission", lazy="selectin")
    nursing_notes = relationship("NursingNote", back_populates="admission", lazy="selectin")
    tests = relationship("AdmissionTest", back_populates="admission", lazy="selectin")
    diets = relationship("AdmissionDiet", back_populates="admission", lazy="selectin")
    discharge = relationship(
        "AdmissionDischarge",
        uselist=False,
        back_populates="admission",
        lazy="selectin"
    )