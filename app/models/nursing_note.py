from sqlalchemy import Column, Integer, String, Date, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.database import Base

class NursingNote(Base):
    __tablename__ = "nursing_notes"

    id = Column(Integer, primary_key=True, index=True)
    admission_id = Column(Integer, ForeignKey("admissions.id"), nullable=False)
    note = Column(Text, nullable=False)
    date = Column(Date, nullable=False)
    added_by = Column(String(100), nullable=False)
    role = Column(String(50), nullable=False)

    admission = relationship("Admission")