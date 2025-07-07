from sqlalchemy import Column, Integer, String, Boolean, Float, ForeignKey, TIMESTAMP
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Receipt(Base):
    __tablename__ = "receipts"

    id = Column(Integer, primary_key=True, index=True)
    hospital_id = Column(Integer, nullable=False)
    patient_id = Column(Integer, nullable=False)
    doctor_id = Column(Integer, nullable=False)
    subtotal = Column(Float, nullable=False)
    discount = Column(Float, nullable=False)
    tax = Column(Float, nullable=False)
    total = Column(Float, nullable=False)
    payment_mode = Column(String, nullable=False)
    is_paid = Column(Boolean, default=False)
    notes = Column(String, nullable=True)
    status = Column(String, nullable=False)
    receipt_unique_no = Column(String, nullable=False)
    
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    line_items = relationship("ReceiptLineItem", back_populates="receipt")


class ReceiptLineItem(Base):
    __tablename__ = "receipt_line_items"

    id = Column(Integer, primary_key=True, index=True)
    receipt_id = Column(Integer, ForeignKey("receipts.id"), nullable=False)
    item = Column(String, nullable=False)
    quantity = Column(Integer, nullable=False)
    rate = Column(Float, nullable=False)
    amount = Column(Float, nullable=False)
    
    receipt = relationship("Receipt", back_populates="line_items")
