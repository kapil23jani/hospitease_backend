from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String, index=True)
    last_name = Column(String, index=True)
    gender = Column(String)
    email = Column(String, index=True)
    phone_number = Column(String, nullable=True)
    password = Column(String)
    role_id = Column(Integer, ForeignKey('roles.id'))
    hospital_id = Column(Integer, ForeignKey('hospitals.id'), nullable=True)  # ✅ New column
    role = relationship('Role', back_populates='users')
    doctor = relationship("Doctor", back_populates="user", uselist=False)
    hospital = relationship("Hospital", foreign_keys=[hospital_id], back_populates="users")

    administered_hospital = relationship("Hospital", foreign_keys='Hospital.admin_id', back_populates="admin", uselist=False)

    staff = relationship("Staff", back_populates="user")