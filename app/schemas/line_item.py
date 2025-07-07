from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class LineItemBase(BaseModel):
    item_id: str
    qty: int
    unit_price: float
    total_price: float
    notes: Optional[str] = None

class LineItemCreate(LineItemBase):
    pass

class LineItemUpdate(BaseModel):
    qty: Optional[int] = None
    unit_price: Optional[float] = None
    total_price: Optional[float] = None
    notes: Optional[str] = None

class LineItemResponse(LineItemBase):
    line_item_id: str
    encounter_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True