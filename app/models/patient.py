from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Patient(Base):
  __tablename__ = "patients"

  id = Column(Integer, primary_key=True, index=True)
  first_name = Column(String, nullable=False)
  middle_name = Column(String, nullable=True)
  last_name = Column(String, nullable=False)
  date_of_birth = Column(String, nullable=True)
  gender = Column(String, nullable=False)
  phone_number = Column(String, nullable=True, unique=True)
  landline = Column(String, nullable=True)
  address = Column(String, nullable=True)
  landmark = Column(String, nullable=True)
  city = Column(String, nullable=True)
  state = Column(String, nullable=True)
  country = Column(String, nullable=True)
  blood_group = Column(String, nullable=True)
  email = Column(String, nullable=True, unique=True)
  occupation = Column(String, nullable=True)
  is_dialysis_patient = Column(Boolean, default=False)

  # hospital_id = Column(Integer, ForeignKey("hospitals.id"), nullable=False)
  # user_id = Column(Integer, ForeignKey("users.id"), nullable=False)

  # hospital = relationship("Hospital", back_populates="patients")
  # user = relationship("User", back_populates="patients")
