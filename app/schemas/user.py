from pydantic import BaseModel, EmailStr
from typing import Optional

# Base schema for User (for general info, without sensitive data like password)
class UserBase(BaseModel):
    first_name: str
    last_name: str
    gender: str
    email: Optional[EmailStr] = None
    phone_number: Optional[str] = None

# Create schema, requiring all fields for user creation
class UserCreate(UserBase):
    password: str    # Password is required for user creation
    role_id: int     # Role is required for user creation

    class Config:
        orm_mode = True

# Update schema for user, password is optional for updating
class UserUpdate(UserBase):
    password: Optional[str] = None  # Password is optional when updating

# Response schema for returning user data
class UserResponse(UserBase):
    id: Optional[int]  # ID is optional in the response model as it might not be available in all situations

    class Config:
        orm_mode = True

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "Bearer"
    user: UserResponse