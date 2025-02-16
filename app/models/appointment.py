from sqlalchemy import Column, Integer, ForeignKey, DateTime, String
from sqlalchemy.orm import relationship
from app.database import Base

class Appointment(Base):
  __tablename__ = "appointments"

  id = Column(Integer, primary_key=True, index=True)
  patient_id = Column(Integer, ForeignKey("patients.id", ondelete="CASCADE"), nullable=False)
  doctor_id = Column(Integer, ForeignKey("doctors.id", ondelete="CASCADE"), nullable=False)
  appointment_datetime = Column(DateTime, nullable=False)
  problem = Column(String, nullable=True)
  appointment_type = Column(String, nullable=True)
  reason = Column(String, nullable=True)

  patient = relationship("Patient", back_populates="appointments")
  doctor = relationship("Doctor", back_populates="appointments")
