from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ABClaimBase(BaseModel):
    urn: Optional[str] = None
    utn: Optional[str] = None
    bis_status: Optional[str] = None
    tms_status: Optional[str] = None
    ehr_json: Optional[str] = None

class ABClaimCreate(ABClaimBase):
    pass

class ABClaimUpdate(BaseModel):
    urn: Optional[str] = None
    utn: Optional[str] = None
    bis_status: Optional[str] = None
    tms_status: Optional[str] = None
    ehr_json: Optional[str] = None

class ABClaimResponse(ABClaimBase):
    ab_claim_id: str
    claim_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True