from pydantic import BaseModel, computed_field, EmailStr
from typing import Optional

class UserBase(BaseModel):
    first_name: str
    last_name: str
    gender: str
    email: Optional[EmailStr] = None
    phone_number: Optional[str] = None
    hospital_id: Optional[int] = None 
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
    gender: Optional[str] = None
    role: Optional[RoleResponse]

    @computed_field
    @property
    def role_name(self) -> Optional[str]:
        """Returns the role name from role object"""
        return self.role.name if self.role else None

    class Config:
        orm_mode = True

    class Config:
        orm_mode = True
class ChangePasswordRequest(BaseModel):
    username: str
    current_password: str
    new_password: str
class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse


class PasswordUpdateRequest(BaseModel):
    user_id: int
    old_password: str
    new_password: str

