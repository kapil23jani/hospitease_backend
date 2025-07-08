from pydantic import BaseModel
from typing import Optional

class BedTypeBase(BaseModel):
    name: str
    description: Optional[str] = None
    amount: float
    charge_type: str

class BedTypeCreate(BedTypeBase):
    pass

class BedTypeUpdate(BedTypeBase):
    pass

class BedTypeOut(BedTypeBase):
    id: int

    class Config:
        from_attributes = True