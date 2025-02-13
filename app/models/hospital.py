from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from app.database import Base

class Hospital(Base):
  __tablename__ = "hospitals"

  id = Column(Integer, primary_key=True, index=True)
  name = Column(String, nullable=False)
  address = Column(String, nullable=True)
  city = Column(String, nullable=True)
  state = Column(String, nullable=True)
  country = Column(String, nullable=True)
  phone_number = Column(String, nullable=True, unique=True)
  email = Column(String, nullable=True, unique=True)

  # patients = relationship("Patient", back_populates="hospital")
