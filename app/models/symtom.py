from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from app.database import Base

class Symptom(Base):
    __tablename__ = "symptoms"

    id = Column(Integer, primary_key=True, index=True)
    description = Column(String, nullable=False)
    duration = Column(String, nullable=False)
    severity = Column(String, nullable=False)
    onset = Column(String, nullable=False)
    contributing_factors = Column(String, nullable=True)
    recurring = Column(Boolean, default=False)
    doctor_comment = Column(String, nullable=True)
    doctor_suggestions = Column(String, nullable=True)
    
    appointment_id = Column(Integer, ForeignKey("appointments.id"))

    appointment = relationship("Appointment", back_populates="symptoms")
