from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.database import Base

class Bed(Base):
    __tablename__ = "beds"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False, unique=True)
    bed_type_id = Column(Integer, ForeignKey("bed_types.id"), nullable=False)
    ward_id = Column(Integer, ForeignKey("wards.id"), nullable=False)
    status = Column(String(50), nullable=False, default="available")  # e.g. available, occupied, maintenance
    features = Column(Text, nullable=True)
    equipment = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True)
    notes = Column(Text, nullable=True)

    bed_type = relationship("BedType")
    ward = relationship("Ward")