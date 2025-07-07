from sqlalchemy import Column, Integer, String, Numeric
from app.database import Base
from sqlalchemy.orm import relationship

class Permission(Base):
    __tablename__ = "permissions"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), unique=True, nullable=False)
    description = Column(String(255), nullable=True)
    amount = Column(Numeric(12, 2), nullable=True)  # <-- Add this line
    hospitals = relationship(
      "Hospital",
      secondary="hospital_permissions",
      back_populates="permissions"
    )