from sqlalchemy import Column, Integer, String, Text, DECIMAL, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Test(Base):
  __tablename__ = "tests"

  id = Column(Integer, primary_key=True, index=True)
  appointment_id = Column(Integer, ForeignKey("appointments.id"), nullable=False)
  test_details = Column(Text, nullable=False)
  status = Column(String(50), nullable=False)
  cost = Column(DECIMAL(10, 2), nullable=True)
  description = Column(Text, nullable=True)
  doctor_notes = Column(Text, nullable=True)
  staff_notes = Column(Text, nullable=True)
  test_date = Column(String, nullable=False)
  test_done_date = Column(String, nullable=True)

  patient = relationship("Appointment", back_populates="tests")
