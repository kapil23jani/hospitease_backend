from sqlalchemy import Column, Integer, String, Float, Text
from app.database import Base

class BedType(Base):
    __tablename__ = "bed_types"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False, unique=True)
    description = Column(Text, nullable=True)
    amount = Column(Float, nullable=False)
    charge_type = Column(String(50), nullable=False)