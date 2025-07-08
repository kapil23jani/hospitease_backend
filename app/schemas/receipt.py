from typing import List, Optional
from pydantic import BaseModel
from datetime import datetime

class ReceiptLineItemBase(BaseModel):
    item: str
    quantity: int
    rate: float
    amount: float

class ReceiptLineItemCreate(ReceiptLineItemBase):
    pass

class ReceiptLineItem(ReceiptLineItemBase):
    id: int
    receipt_id: int

    class Config:
        from_attributes = True

class ReceiptBase(BaseModel):
    hospital_id: int
    patient_id: int
    doctor_id: int
    subtotal: float
    discount: float
    tax: float
    total: float
    payment_mode: str
    is_paid: bool
    notes: Optional[str]
    status: str
    receipt_unique_no: str
    created_at: Optional[datetime]  # Optional created_at field
    updated_at: Optional[datetime]  # Optional updated_at field

class ReceiptCreate(ReceiptBase):
    line_items: List[ReceiptLineItemCreate]

class Receipt(ReceiptBase):
    id: int
    line_items: List[ReceiptLineItem]

    class Config:
        from_attributes = True
