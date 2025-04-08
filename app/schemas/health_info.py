from pydantic import BaseModel, Field
from typing import Optional

class HealthInfoBase(BaseModel):
    known_allergies: Optional[str] = None
    reaction_severity: Optional[str] = None
    reaction_description: Optional[str] = None
    dietary_habits: Optional[str] = None
    physical_activity_level: Optional[str] = None
    sleep_avg_hours: Optional[int] = None
    sleep_quality: Optional[str] = None
    substance_use_smoking: Optional[str] = None
    substance_use_alcohol: Optional[str] = None
    stress_level: Optional[str] = None

class HealthInfoCreate(HealthInfoBase):
    appointment_id: int

class HealthInfoUpdate(HealthInfoBase):
    pass

class HealthInfoResponse(HealthInfoBase):
    id: int
    appointment_id: int

    class Config:
        from_attributes = True
