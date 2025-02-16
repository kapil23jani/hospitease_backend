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

class RoleResponse(BaseModel):
    id: int
    name: str

    class Config:
        orm_mode = True
class UserResponse(UserBase):
    id: Optional[int]
    role: Optional[RoleResponse]  # Add role information

    class Config:
        orm_mode = True

class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse