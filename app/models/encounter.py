from sqlalchemy import Column, Integer, TIMESTAMP, Text, ForeignKey, String
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.line_item import LineItem

class Encounter(Base):
    __tablename__ = "encounters"
    encounter_id = Column(String(20), primary_key=True)
    patient_id = Column(Integer, ForeignKey("patients.id"))
    encounter_date = Column(TIMESTAMP)
    type = Column(String(20))
    status = Column(String(20))
    admission_date = Column(TIMESTAMP)
    discharge_date = Column(TIMESTAMP)
    notes = Column(Text)
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)

    # Association to Patient
    patient = relationship("Patient", back_populates="encounters")
    line_items = relationship("LineItem", back_populates="encounter")