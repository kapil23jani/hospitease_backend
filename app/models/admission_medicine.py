from sqlalchemy import Column, Integer, String, Date, ForeignKey, Text, Boolean
from sqlalchemy.orm import relationship
from app.database import Base

class AdmissionMedicine(Base):
    __tablename__ = "admission_medicines"

    id = Column(Integer, primary_key=True, index=True)
    admission_id = Column(Integer, ForeignKey("admissions.id"), nullable=False)
    medicine_name = Column(String(100), nullable=False)
    dosage = Column(String(50), nullable=True)
    frequency = Column(String(50), nullable=True)  # e.g. TID, BD
    duration = Column(String(50), nullable=True)   # e.g. 5 days
    route = Column(String(50), nullable=True)      # e.g. Oral, IV
    status = Column(String(50), nullable=False, default="active")  # e.g. active, stopped
    prescribed_by = Column(String(100), nullable=True)  # Doctor Name
    prescribed_on = Column(Date, nullable=True)
    prescribed_till = Column(Date, nullable=True)
    notes = Column(Text, nullable=True)

    admission = relationship("Admission")