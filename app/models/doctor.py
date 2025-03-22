from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Date, Text
from sqlalchemy.orm import relationship
from app.database import Base

class Doctor(Base):
    __tablename__ = "doctors"

    id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    specialization = Column(String, nullable=False)
    phone_number = Column(String, nullable=True, unique=True)
    email = Column(String, nullable=True, unique=True)
    experience = Column(Integer, nullable=True)
    is_active = Column(Boolean, default=True)

    # Newly added fields
    title = Column(String(100), nullable=True)
    gender = Column(String(50), nullable=True)
    date_of_birth = Column(Date, nullable=True)
    blood_group = Column(String(10), nullable=True)
    mobile_number = Column(String(20), nullable=True)
    emergency_contact = Column(String(20), nullable=True)
    address = Column(Text, nullable=True)
    city = Column(String(100), nullable=True)
    state = Column(String(100), nullable=True)
    country = Column(String(100), nullable=True)
    zipcode = Column(String(20), nullable=True)
    medical_licence_number = Column(String(100), nullable=True)
    licence_authority = Column(String(255), nullable=True)
    license_expiry_date = Column(Date, nullable=True)

    # Relationships
    hospital_id = Column(Integer, ForeignKey("hospitals.id"), nullable=False)
    hospital = relationship("Hospital", back_populates="doctors")
    
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)  # 🔹 Add this field
    user = relationship("User", back_populates="doctor")  # 🔹 Link to User table

    appointments = relationship("Appointment", back_populates="doctor", cascade="all, delete")
