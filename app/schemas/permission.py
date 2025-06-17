from pydantic import BaseModel, ConfigDict

class PermissionBase(BaseModel):
    name: str
    description: str | None = None
    amount: float | None = None  # <-- Add this line

class PermissionCreate(PermissionBase):
    pass

class PermissionUpdate(PermissionBase):
    pass

class PermissionResponse(BaseModel):
    id: int
    name: str
    description: str | None = None
    amount: float | None = None  # <-- Add this line

    model_config = ConfigDict(from_attributes=True)