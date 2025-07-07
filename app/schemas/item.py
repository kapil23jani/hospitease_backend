from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ItemBase(BaseModel):
    name: str
    category: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None
    is_taxable: Optional[bool] = False

class ItemCreate(ItemBase):
    item_id: str

class ItemUpdate(ItemBase):
    pass

class ItemResponse(ItemBase):
    item_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True