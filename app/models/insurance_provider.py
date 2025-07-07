from sqlalchemy import Column, String, Text, TIMESTAMP
from app.database import Base

class InsuranceProvider(Base):
    __tablename__ = "insurance_providers"
    insurance_id = Column(String(20), primary_key=True)
    name = Column(String(100))
    type = Column(String(50))
    api_endpoint = Column(Text)
    contact_info = Column(Text)
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)