from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class InsuranceClaimBase(BaseModel):
    insurance_id: str
    claim_number: Optional[str] = None
    preauth_number: Optional[str] = None
    status: Optional[str] = None
    submitted_at: Optional[datetime] = None
    approved_at: Optional[datetime] = None
    rejected_at: Optional[datetime] = None
    amount_claimed: Optional[float] = None
    amount_approved: Optional[float] = None

class InsuranceClaimCreate(InsuranceClaimBase):
    pass

class InsuranceClaimUpdate(BaseModel):
    insurance_id: Optional[str] = None
    claim_number: Optional[str] = None
    preauth_number: Optional[str] = None
    status: Optional[str] = None
    submitted_at: Optional[datetime] = None
    approved_at: Optional[datetime] = None
    rejected_at: Optional[datetime] = None
    amount_claimed: Optional[float] = None
    amount_approved: Optional[float] = None

class InsuranceClaimResponse(InsuranceClaimBase):
    claim_id: str
    encounter_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True