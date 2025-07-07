from pydantic import BaseModel
from typing import Optional
from datetime import datetime, date

class PaymentBase(BaseModel):
    payment_date: Optional[date] = None
    amount: float
    mode: Optional[str] = None
    payer: Optional[str] = None
    transaction_ref: Optional[str] = None

class PaymentCreate(PaymentBase):
    pass

class PaymentUpdate(BaseModel):
    payment_date: Optional[date] = None
    amount: Optional[float] = None
    mode: Optional[str] = None
    payer: Optional[str] = None
    transaction_ref: Optional[str] = None

class PaymentResponse(PaymentBase):
    payment_id: str
    invoice_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True