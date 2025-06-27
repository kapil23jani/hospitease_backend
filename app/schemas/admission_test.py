from pydantic import BaseModel
from typing import Optional, List
from datetime import date

class AdmissionTestBase(BaseModel):
    admission_id: int
    test_name: str
    status: Optional[str] = "pending"
    cost: Optional[float] = None
    description: Optional[str] = None
    doctor_notes: Optional[str] = None
    staff_notes: Optional[str] = None
    test_date: Optional[date] = None
    test_done_date: Optional[date] = None
    suggested_by: Optional[str] = None
    performed_by: Optional[str] = None
    report_urls: Optional[List[str]] = None

class AdmissionTestCreate(AdmissionTestBase):
    pass

class AdmissionTestUpdate(AdmissionTestBase):
    pass

class AdmissionTestOut(AdmissionTestBase):
    id: int

    class Config:
        orm_mode = True