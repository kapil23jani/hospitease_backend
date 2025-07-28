from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, BigInteger, Text
from sqlalchemy.orm import relationship
from app.database import Base

class Patient(Base):
    __tablename__ = "patients"

    id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String, nullable=False)
    middle_name = Column(String, nullable=True)
    last_name = Column(String, nullable=False)
    date_of_birth = Column(String, nullable=True)
    gender = Column(String, nullable=False)
    phone_number = Column(String, nullable=True, unique=True)
    landline = Column(String, nullable=True)
    address = Column(String, nullable=True)
    landmark = Column(String, nullable=True)
    city = Column(String, nullable=True)
    state = Column(String, nullable=True)
    country = Column(String, nullable=True)
    blood_group = Column(String, nullable=True)
    email = Column(String, nullable=True)
    occupation = Column(String, nullable=True)
    is_dialysis_patient = Column(Boolean, default=False)
    zipcode = Column(String, nullable=True)
    patient_summary = Column(Text, nullable=True)
    marital_status = Column(String, nullable=True)
    patient_unique_id = Column(String, unique=True, index=True, nullable=False)
    mrd_number = Column(BigInteger, unique=True, nullable=False, index=True)    
    hospital_id = Column(Integer, ForeignKey("hospitals.id"), nullable=False)
    hospital = relationship("Hospital", back_populates="patients")
    appointments = relationship("Appointment", back_populates="patient", cascade="all, delete")
    medical_histories = relationship("MedicalHistory", back_populates="patient", cascade="all, delete-orphan")
    encounters = relationship("Encounter", back_populates="patient")