from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

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
    _tests_docs_urls: Optional[list[str]] = []
    id: Optional[int] = None
    @property
    def tests_docs_urls(self):
        import json
        if isinstance(self._tests_docs_urls, str):
            return json.loads(self._tests_docs_urls)
        return self._tests_docs_urls

    @tests_docs_urls.setter
    def tests_docs_urls(self, value):
        self._tests_docs_urls = value

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
    tests_docs_urls: Optional[list[str]] = None

class TestResponse(BaseModel):
    appointment_id: int
    test_details: str
    status: str
    cost: float
    description: Optional[str] = None
    doctor_notes: Optional[str] = None
    staff_notes: Optional[str] = None
    test_date: str
    test_done_date: Optional[str] = None
    tests_docs_urls: Optional[list[str]] = []
    tests_docs_presigned_urls: Optional[List[str]]  # <-- Add this line

    id: int
    @classmethod
    def from_orm(cls, obj):
        data = super().from_orm(obj).__dict__
        data['tests_docs_urls'] = obj.tests_docs_urls_list
        return cls(**data)

    class Config:
        orm_mode = True
