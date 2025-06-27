from sqlalchemy import Column, Integer, String, Date, ForeignKey, Text, Float, ARRAY
from sqlalchemy.orm import relationship
from app.database import Base

class AdmissionTest(Base):
    __tablename__ = "admission_tests"

    id = Column(Integer, primary_key=True, index=True)
    admission_id = Column(Integer, ForeignKey("admissions.id"), nullable=False)
    test_name = Column(String(100), nullable=False)
    status = Column(String(50), nullable=False, default="pending")  # e.g. pending, completed
    cost = Column(Float, nullable=True)
    description = Column(Text, nullable=True)
    doctor_notes = Column(Text, nullable=True)
    staff_notes = Column(Text, nullable=True)
    test_date = Column(Date, nullable=True)
    test_done_date = Column(Date, nullable=True)
    suggested_by = Column(String(100), nullable=True)  # Doctor Name
    performed_by = Column(String(100), nullable=True)  # Lab Staff Name
    report_urls = Column(ARRAY(String), nullable=True)  # List of file URLs/paths

    admission = relationship("Admission")