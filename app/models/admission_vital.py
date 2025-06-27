from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base

class AdmissionVital(Base):
    __tablename__ = "admission_vitals"

    id = Column(Integer, primary_key=True, index=True)
    admission_id = Column(Integer, ForeignKey("admissions.id"), nullable=False)
    temperature = Column(Float, nullable=True)  # °F
    pulse = Column(Integer, nullable=True)
    blood_pressure = Column(String(20), nullable=True)  # e.g. "120/80"
    spo2 = Column(Integer, nullable=True)  # SpO₂ (%)
    notes = Column(Text, nullable=True)
    recorded_at = Column(DateTime(timezone=True), nullable=False, server_default=func.now())
    captured_by = Column(String(100), nullable=True)

    admission = relationship("Admission")