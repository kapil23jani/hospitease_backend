from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Medicine(Base):
    __tablename__ = "medicines"

    id = Column(Integer, primary_key=True, index=True)
    appointment_id = Column(Integer, ForeignKey("appointments.id"), nullable=False)
    name = Column(String, nullable=False)
    dosage = Column(String, nullable=False)
    frequency = Column(String, nullable=False)
    duration = Column(String, nullable=False)
    start_date = Column(String, nullable=False)
    status = Column(String, nullable=False)
    time_interval = Column(String, nullable=False)
    route = Column(String, nullable=False)
    quantity = Column(String, nullable=False)
    instruction = Column(String, nullable=False)
    appointment = relationship("Appointment", back_populates="medicines")
