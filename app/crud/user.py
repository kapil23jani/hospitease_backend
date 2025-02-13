from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from app.models.user import User
from app.schemas.user import UserCreate
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from app.utils import hash_password, verify_password, create_access_token

from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from app.models.user import User

async def create_user(db: AsyncSession, user: UserCreate):
  try:
    new_user = User(
      first_name=user.first_name,
      last_name=user.last_name,
      gender=user.gender,
      email=user.email,
      phone_number=user.phone_number,
      password=user.password,
      role_id=user.role_id
    )
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)
    return new_user
  except IntegrityError as e:
    db.rollback()
    raise HTTPException(status_code=400, detail=f"Integrity Error: {str(e)}")


async def get_user(db: AsyncSession, user_id: int):
    async with db.begin():
        result = await db.execute(select(User).where(User.id == user_id))
        user = result.scalars().first()
    return user

async def get_users(db: AsyncSession, skip: int = 0, limit: int = 100):
    async with db.begin():
        result = await db.execute(select(User).offset(skip).limit(limit))
        users = result.scalars().all()
    return users

async def update_user(db: AsyncSession, user_id: int, user_data: UserCreate):
    user = await get_user(db, user_id)
    for key, value in user_data.dict().items():
        setattr(user, key, value)
    try:
        await db.commit()
        await db.refresh(user)
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail="Error updating user.")
    return user

async def delete_user(db: AsyncSession, user_id: int):
    user = await get_user(db, user_id)
    await db.delete(user)
    await db.commit()
    return user

async def authenticate_user(db: AsyncSession, email: str, password: str):
    result = await db.execute(select(User).where(User.email == email))
    user = result.scalars().first()

    if not user or not verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    return user
