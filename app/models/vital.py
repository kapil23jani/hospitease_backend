from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class Vital(Base):
    __tablename__ = "vitals"

    id = Column(Integer, primary_key=True, index=True)
    appointment_id = Column(Integer, ForeignKey("appointments.id", ondelete="CASCADE"), nullable=False)
    capture_date = Column(String, nullable=True)
    vital_name = Column(String, nullable=False)
    vital_value = Column(String, nullable=False)
    vital_unit = Column(String, nullable=False)
    recorded_by = Column(String, nullable=False)
    recorded_at = Column(String, nullable=True)

    appointment = relationship("Appointment", back_populates="vitals")
