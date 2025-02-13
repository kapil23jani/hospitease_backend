from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas import UserCreate, UserUpdate, UserResponse
from app.database import get_db
from app.crud.user import create_user, get_user, get_users, update_user, delete_user
from fastapi.security import OAuth2PasswordRequestForm
from app.database import get_db
from app.schemas.user import UserCreate, TokenResponse, UserResponse
from app.crud.user import create_user, authenticate_user
from app.utils import create_access_token
from datetime import timedelta

router = APIRouter()

router = APIRouter()

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

@router.post("/login", response_model=TokenResponse)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)):
    user = await authenticate_user(db, form_data.username, form_data.password)
    access_token = create_access_token(data={"sub": user.email, "role": user.role_id}, expires_delta=timedelta(minutes=30))
    
    return {
        "access_token": access_token,
        "token_type": "Bearer",
        "user": {
            "id": user.id,
            "email": user.email,
            "role_id": user.role_id,
            "first_name": user.first_name,
            "last_name": user.last_name
        }
    }

@router.post("/logout")
async def logout():
    return {"message": "Logout successful"}