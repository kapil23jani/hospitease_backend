from sqlalchemy import (
    Column, Integer, String, ForeignKey, Boolean, Text, Date, DateTime, JSON, func, ARRAY
)
from sqlalchemy.orm import relationship
from app.database import Base

class Hospital(Base):
    __tablename__ = "hospitals"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    registration_number = Column(String(100), nullable=True)
    type = Column(String(100), nullable=True)
    address = Column(String, nullable=True)
    logo_url = Column(Text, nullable=True)
    website = Column(String(255), nullable=True)
    admin_id = Column(Integer, ForeignKey("users.id", ondelete="SET NULL"), unique=True, nullable=True)
    admin = relationship("User", back_populates="hospital", uselist=False, foreign_keys=[admin_id])
    owner_name = Column(String(255), nullable=True)
    admin_contact_number = Column(String(20), nullable=True)
    number_of_beds = Column(Integer, nullable=True)
    departments = Column(ARRAY(Text), nullable=True)
    specialties = Column(ARRAY(Text), nullable=True)
    facilities = Column(ARRAY(Text), nullable=True)
    ambulance_services = Column(Boolean, default=False)
    opening_hours = Column(JSON, nullable=True)
    license_number = Column(String(100), nullable=True)
    license_expiry_date = Column(Date, nullable=True)
    is_accredited = Column(Boolean, default=False)
    external_id = Column(String(255), nullable=True)
    timezone = Column(String(50), nullable=True)
    is_active = Column(Boolean, default=True)
    city = Column(String(100), nullable=True)
    state = Column(String(100), nullable=True)
    country = Column(String(100), nullable=True)
    phone_number = Column(String(20), nullable=True)
    zipcode = Column(String(20), nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)
    patients = relationship("Patient", back_populates="hospital", cascade="all, delete")
    doctors = relationship("Doctor", back_populates="hospital")
    users = relationship("User", foreign_keys='User.hospital_id', back_populates="hospital")
    admin = relationship("User", foreign_keys=[admin_id], back_populates="administered_hospital")
    permissions = relationship(
        "Permission",
        secondary="hospital_permissions",
        back_populates="hospitals"
    )
    hospital_payments = relationship(
        "HospitalPayment",
        back_populates="hospital",
        cascade="all, delete-orphan"
    )

    staff_members = relationship("Staff", back_populates="hospital")
    wards = relationship("Ward", back_populates="hospital")
    admissions = relationship("Admission", back_populates="hospital")