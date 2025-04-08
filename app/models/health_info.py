from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class HealthInfo(Base):
    __tablename__ = "health_info"

    id = Column(Integer, primary_key=True, index=True)
    appointment_id = Column(Integer, ForeignKey("appointments.id"), nullable=False, unique=True)

    known_allergies = Column(String, nullable=True)
    reaction_severity = Column(String, nullable=True)
    reaction_description = Column(String, nullable=True)
    dietary_habits = Column(String, nullable=True)
    physical_activity_level = Column(String, nullable=True)
    sleep_avg_hours = Column(Integer, nullable=True)
    sleep_quality = Column(String, nullable=True)
    substance_use_smoking = Column(String, nullable=True)
    substance_use_alcohol = Column(String, nullable=True)
    stress_level = Column(String, nullable=True)

    appointment = relationship("Appointment", back_populates="health_info")
