from pydantic import BaseModel
from typing import Optional

class RoleBase(BaseModel):
    name: str

class RoleCreate(RoleBase):
    pass

class RoleUpdate(BaseModel):
    name: str

class RoleResponse(RoleBase):
    id: Optional[int]

    class Config:
        from_attributes = True
