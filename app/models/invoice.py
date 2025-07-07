from sqlalchemy import Column, String, DECIMAL, Boolean, Date, TIMESTAMP, ForeignKey
from app.database import Base

class Invoice(Base):
    __tablename__ = "invoices"
    invoice_id = Column(String(20), primary_key=True)
    encounter_id = Column(String(20), ForeignKey("encounters.encounter_id"))
    total_amount = Column(DECIMAL(10, 2))
    paid_amount = Column(DECIMAL(10, 2))
    balance = Column(DECIMAL(10, 2))
    status = Column(String(20))
    credit_allowed = Column(Boolean, default=False)
    due_date = Column(Date)
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)