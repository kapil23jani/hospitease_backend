from fastapi import APIRouter, Depends, HTTPException, Form
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas import UserCreate, UserUpdate, UserResponse
from app.database import get_db
from app.crud.user import create_user, get_user, get_users, update_user, delete_user, change_password
from fastapi.security import OAuth2PasswordRequestForm
from app.database import get_db
from app.schemas.user import UserCreate, TokenResponse, UserResponse, ChangePasswordRequest
from app.crud.user import create_user, authenticate_user
from app.utils import create_access_token
from datetime import timedelta
import logging
from sqlalchemy import select
from passlib.context import CryptContext
from app.models import User

router = APIRouter()

router = APIRouter()
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@router.post("/", response_model=UserResponse)
async def create_user_api(user: UserCreate, db: AsyncSession = Depends(get_db)):
    return await create_user(db, user)

@router.get("/{user_id}", response_model=UserResponse)
async def get_user_api(user_id: int, db: AsyncSession = Depends(get_db)):
    user = await get_user(db, user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.get("/", response_model=list[UserResponse])
async def get_users_api(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    users = await get_users(db, skip=skip, limit=limit)
    return users

@router.put("/{user_id}", response_model=UserResponse)
async def update_user_api(user_id: int, user: UserUpdate, db: AsyncSession = Depends(get_db)):
    updated_user = await update_user(db, user_id, user)
    if updated_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return updated_user

@router.delete("/{user_id}", response_model=UserResponse)
async def delete_user_api(user_id: int, db: AsyncSession = Depends(get_db)):
    user = await delete_user(db, user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.post("/login", response_model=UserResponse)
async def login( email: str, password: str, db: AsyncSession = Depends(get_db),):
    
    user = await authenticate_user(db, email, password)
    logger.info(f"Received login request: email={email}, password={password}")
    if not user:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    return user 

@router.delete("/logout")
async def logout():
    return {"message": "Logout successful"}

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
async def change_password(db: AsyncSession, email: str, current_password: str, new_password: str):
    result = await db.execute(select(User).where(User.email == email))
    user = result.scalar_one_or_none()
    if user is None:
        return {"error": "User not found"}
    if not pwd_context.verify(current_password, user.hashed_password):
        return {"error": "Current password is incorrect"}
    user.hashed_password = pwd_context.hash(new_password)
    await db.commit()
    return {"message": "Password updated successfully"}