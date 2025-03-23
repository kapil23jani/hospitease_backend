from sqlalchemy import Column, Integer, ForeignKey, DateTime, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import text
from app.database import Base
class Appointment(Base):
    __tablename__ = "appointments"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"))
    doctor_id = Column(Integer, ForeignKey("doctors.id"))
    appointment_datetime = Column(DateTime)
    problem = Column(String, nullable=True)
    appointment_type = Column(String, nullable=True)
    reason = Column(String, nullable=True)

    patient = relationship("Patient", back_populates="appointments", lazy="selectin")
    doctor = relationship("Doctor", back_populates="appointments", lazy="selectin")
    symptoms = relationship("Symptom", back_populates="appointment", cascade="all, delete-orphan")
    vitals = relationship("Vital", back_populates="appointment")
    tests = relationship("Test", back_populates="patient")
    medicines = relationship("Medicine", back_populates="appointment")