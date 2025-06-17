from pydantic import BaseModel, ConfigDict
from datetime import date

class HospitalPaymentBase(BaseModel):
    hospital_id: int
    date: date
    amount: float
    payment_method: str
    reference: str | None = None
    status: str
    paid: bool = False
    remarks: str | None = None

class HospitalPaymentCreate(HospitalPaymentBase):
    pass

class HospitalPaymentUpdate(HospitalPaymentBase):
    pass

class HospitalPaymentResponse(BaseModel):
    id: int
    hospital_id: int
    date: date
    amount: float
    payment_method: str
    reference: str | None = None
    status: str
    paid: bool = False
    remarks: str | None = None

    model_config = ConfigDict(from_attributes=True)

class HospitalShortInfo(BaseModel):
    id: int
    name: str

    class Config:
        orm_mode = True

class HospitalPaymentWithHospitalResponse(BaseModel):
    transaction_id: str
    hospital: HospitalShortInfo
    date: date
    payment_type: str
    amount: float
    status: str
    id: int

    class Config:
        orm_mode = True