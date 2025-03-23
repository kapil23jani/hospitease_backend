from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class TestBase(BaseModel):
    appointment_id: int
    test_details: str
    status: str
    cost: float
    description: Optional[str] = None
    doctor_notes: Optional[str] = None
    staff_notes: Optional[str] = None
    test_date: str
    test_done_date: Optional[str] = None

class TestCreate(TestBase):
    pass

class TestUpdate(BaseModel):
    test_details: Optional[str] = None
    status: Optional[str] = None
    cost: Optional[float] = None
    description: Optional[str] = None
    doctor_notes: Optional[str] = None
    staff_notes: Optional[str] = None
    test_done_date: Optional[str] = None

class TestResponse(TestBase):
    id: int

    class Config:
        from_attributes = True
