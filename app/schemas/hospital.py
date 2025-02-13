from pydantic import BaseModel
from typing import Optional

class HospitalCreate(BaseModel):
  name: str
  address: Optional[str] = None
  city: Optional[str] = None
  state: Optional[str] = None
  country: Optional[str] = None
