from sqlalchemy import Column, String, DECIMAL, Date, TIMESTAMP, ForeignKey
from app.database import Base

class Payment(Base):
    __tablename__ = "payments"
    payment_id = Column(String(20), primary_key=True)
    invoice_id = Column(String(20), ForeignKey("invoices.invoice_id"))
    payment_date = Column(Date)
    amount = Column(DECIMAL(10, 2))
    mode = Column(String(20))
    payer = Column(String(50))
    transaction_ref = Column(String(50))
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)