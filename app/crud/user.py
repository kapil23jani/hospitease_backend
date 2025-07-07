from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from passlib.context import CryptContext
from sqlalchemy.orm import selectinload
from app.models.user import User
from app.schemas.user import UserCreate
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from app.utils import hash_password, verify_password
from sqlalchemy.orm import joinedload
import logging
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from app.models.user import User
from typing import List, Optional


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

from sqlalchemy.future import select
from sqlalchemy.orm import selectinload

async def create_user(db: AsyncSession, user: UserCreate):
    try:
        hashed_password = pwd_context.hash(user.password)

        new_user = User(
            first_name=user.first_name,
            last_name=user.last_name,
            gender=user.gender,
            email=user.email,
            phone_number=user.phone_number,
            password=user.password,  # Ensure hashed_password is used
            role_id=user.role_id,
            hospital_id=user.hospital_id,  # Optional field
        )
        db.add(new_user)
        await db.commit()

        # Refresh using eager loading to avoid lazy load issues
        result = await db.execute(
            select(User).options(selectinload(User.role)).where(User.id == new_user.id)
        )
        user_with_role = result.scalars().first()

        return user_with_role

    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=f"Integrity Error: {str(e)}")
    
async def get_user(db: AsyncSession, user_id: int):
    result = await db.execute(
        select(User).options(selectinload(User.role)).where(User.id == user_id)
    )
    user = result.scalars().first()
    return user


async def get_users(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(User).options(selectinload(User.role)).offset(skip).limit(limit)
    )
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

async def get_user_by_email(db: AsyncSession, email: str):
    result = await db.execute(select(User).where(User.email == email))
    return result.scalar_one_or_none()

async def authenticate_user(db: AsyncSession, email: str, password: str):
    user = await get_user_by_email(db, email)
    if not user:
        logger.info(f"Received login request: password={password}, user not found for email={email}")
        return None
    logger.info(f"Received login request: password={password}, password={user.password}")
    logger.info(f"Received login request: user_bbj={user}")
    if password.strip() != user.password.strip():
        return None
    logger.info(f"[authenticate_user] Authentication successful for user: {email}")

    # Eagerly load role before returning
    result = await db.execute(
        select(User).options(selectinload(User.role)).where(User.id == user.id)
    )
    user_with_role = result.scalars().first()
    return user_with_role

async def change_password(db: AsyncSession, email: str, current_password: str, new_password: str):
    user = db.query(User).filter(User.email == email).first()
    if not user:
        return {"error": "User not found"}

    if not (User.password == current_password):
        return {"error": "Current password is incorrect"}

    user.password = new_password
    db.commit()
    db.refresh(user)
    return {"success": True}

async def get_users_by_hospital(
    db: AsyncSession, hospital_id: int, role_id: Optional[int] = None
) -> List[User]:
    query = select(User).options(selectinload(User.role)).where(User.hospital_id == hospital_id)

    if role_id is not None:
        query = query.where(User.role_id == role_id)

    result = await db.execute(query)
    return result.scalars().all()