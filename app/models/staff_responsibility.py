from sqlalchemy import Column, String, Integer, DateTime, ForeignKey, Table, select
from sqlalchemy.orm import relationship, declarative_base, selectinload
from datetime import datetime
from uuid import uuid4

Base = declarative_base()

class StaffResponsibility(Base):
    __tablename__ = "staff_responsibilities"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, nullable=False)
    description = Column(String, nullable=True)

class StaffResponsibilityAssignment(Base):
    __tablename__ = "staff_responsibility_assignments"
    id = Column(Integer, primary_key=True, index=True)
    staff_id = Column(Integer, nullable=False)
    responsibility_id = Column(Integer, ForeignKey("staff_responsibilities.id"))
    assigned_by = Column(Integer, nullable=False)
    assigned_at = Column(DateTime, default=datetime.utcnow)
    revoked_at = Column(DateTime, nullable=True)
    revoked_by = Column(Integer, nullable=True)
    responsibility = relationship("StaffResponsibility", lazy="joined")
