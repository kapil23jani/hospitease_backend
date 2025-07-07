from pydantic import BaseModel
from typing import Optional
from datetime import datetime, date

class CreditLedgerBase(BaseModel):
    due_date: Optional[date] = None
    amount_due: float
    amount_paid: Optional[float] = 0.0
    status: Optional[str] = None

class CreditLedgerCreate(CreditLedgerBase):
    pass

class CreditLedgerUpdate(BaseModel):
    due_date: Optional[date] = None
    amount_due: Optional[float] = None
    amount_paid: Optional[float] = None
    status: Optional[str] = None

class CreditLedgerResponse(CreditLedgerBase):
    credit_id: str
    invoice_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True