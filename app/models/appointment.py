from sqlalchemy import Column, Integer, ForeignKey, DateTime, String, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import text
from app.database import Base

class Appointment(Base):
    __tablename__ = "appointments"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"))
    doctor_id = Column(Integer, ForeignKey("doctors.id"))
    appointment_datetime = Column(String, nullable=True)
    problem = Column(String, nullable=True)
    appointment_type = Column(String, nullable=True)
    reason = Column(String, nullable=True)
    created_at = Column(DateTime, nullable=False)
    updated_at = Column(DateTime, nullable=False)
    hospital_id =  Column(Integer, nullable=True)
    blood_pressure = Column(String, nullable=True)
    pulse_rate = Column(String, nullable=True)
    temperature = Column(String, nullable=True)
    spo2 = Column(String, nullable=True)
    weight = Column(String, nullable=True)
    additional_notes = Column(Text, nullable=True)
    advice = Column(Text, nullable=True)
    follow_up_date = Column(String, nullable=True)
    follow_up_notes = Column(Text, nullable=True)
    appointment_date = Column(Text, nullable=True)
    appointment_time = Column(Text, nullable=True)
    status = Column(Text, nullable=True)
    appointment_unique_id = Column(String, unique=True, index=True, nullable=False)
    mode_of_appointment = Column(String, nullable=True)
    patient = relationship("Patient", back_populates="appointments", lazy="selectin")
    doctor = relationship("Doctor", back_populates="appointments", lazy="selectin")
    symptoms = relationship("Symptom", back_populates="appointment", cascade="all, delete-orphan")
    vitals = relationship("Vital", back_populates="appointment")
    tests = relationship("Test", back_populates="patient")
    medicines = relationship("Medicine", back_populates="appointment")
    documents = relationship(
        "AppointmentDocument",
        primaryjoin="and_(Appointment.id == foreign(Document.documentable_id), Document.documentable_type == 'appointment')",
        lazy="selectin"
    )
    health_info = relationship("HealthInfo", back_populates="appointment", uselist=False, cascade="all, delete-orphan")
    family_histories = relationship("FamilyHistory", back_populates="appointment")
