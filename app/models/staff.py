from sqlalchemy import Column, Integer, String, Boolean, Date, Text, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Staff(Base):
    __tablename__ = "staff"

    id = Column(Integer, primary_key=True, index=True)
    hospital_id = Column(Integer, ForeignKey("hospitals.id"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)  # 🔹 Add this field
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    title = Column(String(50))
    gender = Column(String(10))
    date_of_birth = Column(Date)
    phone_number = Column(String(20), unique=True)
    email = Column(String(100), unique=True)
    role = Column(String(50), nullable=False)
    department = Column(String(100))
    specialization = Column(String(100))
    qualification = Column(Text)
    experience = Column(Integer)
    joining_date = Column(Date)
    is_active = Column(Boolean, default=True)
    address = Column(Text)
    city = Column(String(100))
    state = Column(String(100))
    country = Column(String(100))
    zipcode = Column(String(20))
    emergency_contact = Column(String(20))
    photo_url = Column(Text)
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)

    # Relationships
    hospital = relationship("Hospital", back_populates="staff_members")
    user = relationship("User", back_populates="staff")  # 🔹 Link to User table