from pydantic import BaseModel
from typing import List

class HospitalPermissionBase(BaseModel):
    hospital_id: int
    permission_id: int

class HospitalPermissionCreate(HospitalPermissionBase):
    pass

class HospitalPermissionResponse(HospitalPermissionBase):
    id: int

    class Config:
        orm_mode = True

class HospitalPermissionBulkCreate(BaseModel):
    hospital_id: int
    permission_ids: List[int]