from pydantic import BaseModel
from typing import Optional
from datetime import datetime, date

class InvoiceBase(BaseModel):
    total_amount: float
    paid_amount: float
    balance: float
    status: Optional[str] = None
    credit_allowed: Optional[bool] = False
    due_date: Optional[date] = None

class InvoiceCreate(InvoiceBase):
    pass

class InvoiceUpdate(BaseModel):
    total_amount: Optional[float] = None
    paid_amount: Optional[float] = None
    balance: Optional[float] = None
    status: Optional[str] = None
    credit_allowed: Optional[bool] = None
    due_date: Optional[date] = None

class InvoiceResponse(InvoiceBase):
    invoice_id: str
    encounter_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True