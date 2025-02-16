from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from passlib.context import CryptContext
from sqlalchemy.orm import selectinload
from app.models.user import User
from app.schemas.user import UserCreate
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from app.utils import hash_password, verify_password, create_access_token
from sqlalchemy.orm import joinedload

from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from app.models.user import User

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def create_user(db: AsyncSession, user: UserCreate):
    try:
        hashed_password = pwd_context.hash(user.password)  # Hash the password

        new_user = User(
            first_name=user.first_name,
            last_name=user.last_name,
            gender=user.gender,
            email=user.email,
            phone_number=user.phone_number,
            password=hashed_password,  # Store the hashed password
            role_id=user.role_id
        )
        db.add(new_user)
        await db.commit()
        await db.refresh(new_user)
        return new_user
    except IntegrityError as e:
        await db.rollback()
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

async def get_user_by_email(db: AsyncSession, email: str):
    result = await db.execute(select(User).where(User.email == email))
    return result.scalar_one_or_none()

async def authenticate_user(db: AsyncSession, email: str, password: str):
    stmt = select(User).options(joinedload(User.role)).where(User.email == email)
    result = await db.execute(stmt)
    user = result.scalars().first()

    if not user or not verify_password(password, user.password):
        return None

    return user