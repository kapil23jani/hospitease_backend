from sqlalchemy import Column, Integer, String, Date, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.database import Base

class MedicalHistory(Base):
    __tablename__ = "medical_histories"

    id = Column(Integer, primary_key=True, index=True)
    condition = Column(String, nullable=False)
    diagnosis_date = Column(Date, nullable=True)
    treatment = Column(Text, nullable=True)
    doctor = Column(String, nullable=True)
    hospital = Column(String, nullable=True)
    status = Column(String, nullable=True)

    patient_id = Column(Integer, ForeignKey("patients.id", ondelete="CASCADE"))
    patient = relationship("Patient", back_populates="medical_histories")
