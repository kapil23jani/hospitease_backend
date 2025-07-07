from pydantic import BaseModel
from typing import Optional
from datetime import date

class NursingNoteBase(BaseModel):
    admission_id: int
    note: str
    date: date
    added_by: str
    role: str

class NursingNoteCreate(NursingNoteBase):
    pass

class NursingNoteUpdate(NursingNoteBase):
    pass

class NursingNoteOut(NursingNoteBase):
    id: int

    class Config:
        orm_mode = True