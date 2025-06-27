from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Text, DateTime, ARRAY
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import sqlalchemy.dialects.postgresql as pg

class AdmissionDiet(Base):
    __tablename__ = "admission_diets"

    id = Column(Integer, primary_key=True, index=True)
    admission_id = Column(Integer, ForeignKey("admissions.id"), nullable=False)
    diet_type = Column(String(100), nullable=False)
    is_veg = Column(Boolean, nullable=False, default=True)
    allergies = Column(ARRAY(String), nullable=True)
    meals = Column(pg.JSONB, nullable=False)  # List of meal objects
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    admission = relationship("Admission")