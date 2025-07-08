from pydantic import BaseModel
from typing import Optional

class BedBase(BaseModel):
    name: str
    bed_type_id: int
    ward_id: int
    status: Optional[str] = "available"
    features: Optional[str] = None
    equipment: Optional[str] = None
    is_active: Optional[bool] = True
    notes: Optional[str] = None

class BedCreate(BedBase):
    pass

class BedUpdate(BedBase):
    pass

class BedOut(BedBase):
    id: int

    class Config:
        from_attributes = True