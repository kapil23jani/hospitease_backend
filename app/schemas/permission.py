from pydantic import BaseModel

class PermissionBase(BaseModel):
    name: str
    description: str | None = None
    amount: float | None = None  # <-- Add this line

class PermissionCreate(PermissionBase):
    pass

class PermissionUpdate(PermissionBase):
    pass

class PermissionResponse(PermissionBase):
    id: int

    class Config:
        orm_mode = True