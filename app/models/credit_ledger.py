from sqlalchemy import Column, String, DECIMAL, Date, TIMESTAMP, ForeignKey
from app.database import Base

class CreditLedger(Base):
    __tablename__ = "credit_ledgers"
    credit_id = Column(String(20), primary_key=True)
    invoice_id = Column(String(20), ForeignKey("invoices.invoice_id"))
    due_date = Column(Date)
    amount_due = Column(DECIMAL(10, 2))
    amount_paid = Column(DECIMAL(10, 2), default=0.0)
    status = Column(String(20))
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)