from pydantic import BaseModel
from typing import Optional

class WardBase(BaseModel):
    name: str
    description: Optional[str] = None
    floor: Optional[str] = None
    total_beds: int
    available_beds: int
    is_active: Optional[bool] = True
    hospital_id: int

class WardCreate(WardBase):
    pass

class WardUpdate(WardBase):
    pass

class WardOut(WardBase):
    id: int

    class Config:
        orm_mode = True