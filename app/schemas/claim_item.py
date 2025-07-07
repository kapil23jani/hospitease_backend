from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ClaimItemBase(BaseModel):
    line_item_id: str
    claimed_amount: float
    approved_amount: Optional[float] = None

class ClaimItemCreate(ClaimItemBase):
    pass

class ClaimItemUpdate(BaseModel):
    claimed_amount: Optional[float] = None
    approved_amount: Optional[float] = None

class ClaimItemResponse(ClaimItemBase):
    claim_item_id: str
    claim_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True