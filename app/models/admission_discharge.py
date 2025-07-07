from sqlalchemy import Column, Integer, String, Date, DateTime, Boolean, ForeignKey, JSON
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base

class AdmissionDischarge(Base):
    __tablename__ = "admission_discharges"

    id = Column(Integer, primary_key=True, index=True)
    admission_id = Column(Integer, ForeignKey("admissions.id"), nullable=False)
    discharge_date = Column(DateTime, nullable=False)
    discharge_type = Column(String(50), nullable=False)
    summary = Column(String, nullable=True)
    follow_up_date = Column(Date, nullable=True)
    follow_up_instructions = Column(String, nullable=True)
    attending_doctor = Column(String, nullable=True)
    checklist = Column(JSON, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    admission = relationship(
        "Admission",
        back_populates="discharge",
        lazy="selectin"
    )