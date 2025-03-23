from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class VitalCreate(BaseModel):
    appointment_id: int
    capture_date: str
    vital_name: str
    vital_value: str
    vital_unit: str
    recorded_by: str
    recorded_at: str

class VitalResponse(VitalCreate):
    id: int

    class Config:
        from_attributes = True  # ✅ Ensures SQLAlchemy model compatibility
