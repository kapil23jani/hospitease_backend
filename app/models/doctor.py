from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Doctor(Base):
  __tablename__ = "doctors"

  id = Column(Integer, primary_key=True, index=True)
  first_name = Column(String, nullable=False)
  last_name = Column(String, nullable=False)
  specialization = Column(String, nullable=False)
  phone_number = Column(String, nullable=True, unique=True)
  email = Column(String, nullable=True, unique=True)
  experience = Column(Integer, nullable=True)
  is_active = Column(Boolean, default=True)

  hospital_id = Column(Integer, ForeignKey("hospitals.id"), nullable=False)
  hospital = relationship("Hospital", back_populates="doctors")
  appointments = relationship("Appointment", back_populates="doctor", cascade="all, delete")
