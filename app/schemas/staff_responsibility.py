from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class StaffResponsibilityBase(BaseModel):
    name: str
    description: Optional[str] = None

class StaffResponsibilityCreate(StaffResponsibilityBase):
    pass

class StaffResponsibilityResponse(StaffResponsibilityBase):
    id: int

    class Config:
        from_attributes = True

class StaffResponsibilityAssignmentBase(BaseModel):
    staff_id: int
    responsibility_id: int

class StaffResponsibilityAssignmentCreate(StaffResponsibilityAssignmentBase):
    assigned_by: int

class StaffResponsibilityAssignmentResponse(StaffResponsibilityAssignmentBase):
    id: int
    assigned_by: int
    assigned_at: datetime
    revoked_at: Optional[datetime]
    revoked_by: Optional[int]  # <-- Change from str to int
    responsibility: StaffResponsibilityResponse

    class Config:
        from_attributes = True