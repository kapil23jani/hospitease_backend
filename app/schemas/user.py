from pydantic import BaseModel, EmailStr
from typing import Optional
class UserBase(BaseModel):
    first_name: str
    last_name: str
    gender: str
    email: Optional[EmailStr] = None
    phone_number: Optional[str] = None
class UserCreate(UserBase):
    password: str    
    role_id: int     

    class Config:
        orm_mode = True
        
class UserUpdate(UserBase):
    password: Optional[str] = None
    
class UserResponse(UserBase):
    id: Optional[int]

    class Config:
        orm_mode = True

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "Bearer"
    user: UserResponse