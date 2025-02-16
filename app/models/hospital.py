from sqlalchemy import Column, Integer, String, ForeignKey
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
    phone_number = Column(String, nullable=True)
    email = Column(String, nullable=True)

    patients = relationship("Patient", back_populates="hospital", cascade="all, delete")
    doctors = relationship("Doctor", back_populates="hospital")
    admin_id = Column(Integer, ForeignKey("users.id", ondelete="SET NULL"), unique=True, nullable=True)
    admin = relationship("User", back_populates="hospital", uselist=False, foreign_keys=[admin_id])
