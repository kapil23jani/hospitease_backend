from typing import List, Optional
from datetime import date, datetime
from pydantic import BaseModel

from app.schemas.admission_vital import AdmissionVitalOut
from app.schemas.admission_medicine import AdmissionMedicineOut
from app.schemas.nursing_note import NursingNoteOut
from app.schemas.admission_test import AdmissionTestOut
from app.schemas.admission_diet import AdmissionDietOut
from app.schemas.admission_discharge import AdmissionDischargeOut

class AdmissionBase(BaseModel):
    patient_id: int
    appointment_id: Optional[int] = None
    doctor_id: int
    hospital_id: int  # <-- add this line
    admission_date: date
    reason: Optional[str] = None
    status: Optional[str] = "admitted"
    bed_id: Optional[int] = None
    discharge_date: Optional[date] = None
    critical_care_required: Optional[bool] = False
    care_24x7_required: Optional[bool] = False
    notes: Optional[str] = None

class AdmissionCreate(AdmissionBase):
    pass

class AdmissionUpdate(AdmissionBase):
    pass

class AdmissionOut(BaseModel):
    id: int
    patient_id: int
    appointment_id: Optional[int]
    doctor_id: int
    hospital_id: int  # <-- add this line
    admission_date: date
    reason: Optional[str]
    status: Optional[str]
    bed_id: Optional[int]
    discharge_date: Optional[date]
    critical_care_required: Optional[bool]
    care_24x7_required: Optional[bool]
    notes: Optional[str]
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    vitals: List[AdmissionVitalOut] = []
    medicines: List[AdmissionMedicineOut] = []
    nursing_notes: List[NursingNoteOut] = []
    tests: List[AdmissionTestOut] = []
    diets: List[AdmissionDietOut] = []
    discharge: Optional[AdmissionDischargeOut] = None

    class Config:
        orm_mode = True