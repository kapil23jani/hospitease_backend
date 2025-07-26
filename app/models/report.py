from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.ext.declarative import declarative_base
import datetime

Base = declarative_base()

class Report(Base):
    __tablename__ = "reports"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    type = Column(String, nullable=False)
    date_from = Column(String, nullable=True)
    date_to = Column(String, nullable=True)
    criteria = Column(JSONB, nullable=False)  # Store the full request object
    result = Column(JSONB, nullable=True)     # Store the result data
    created_at = Column(DateTime, default=datetime.datetime.utcnow)