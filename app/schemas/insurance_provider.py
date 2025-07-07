from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class InsuranceProviderBase(BaseModel):
    name: str
    type: Optional[str] = None
    api_endpoint: Optional[str] = None
    contact_info: Optional[str] = None

class InsuranceProviderCreate(InsuranceProviderBase):
    insurance_id: str

class InsuranceProviderUpdate(BaseModel):
    name: Optional[str] = None
    type: Optional[str] = None
    api_endpoint: Optional[str] = None
    contact_info: Optional[str] = None

class InsuranceProviderResponse(InsuranceProviderBase):
    insurance_id: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True