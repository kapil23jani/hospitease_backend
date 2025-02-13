from sqlalchemy.orm import Session
from app.models.role import Role
from app.schemas.role import RoleCreate
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession

async def create_role(db: AsyncSession, role: RoleCreate):
    db_role = Role(**role.dict())
    db.add(db_role)
    await db.commit()
    await db.refresh(db_role)
    return db_role


async def get_role(db: AsyncSession, role_id: int):
    result = await db.execute(select(Role).filter(Role.id == role_id))
    return result.scalars().first()

async def get_roles(db: AsyncSession, skip: int = 0, limit: int = 10):
    stmt = select(Role).offset(skip).limit(limit)
    result = await db.execute(stmt)
    return result.scalars().all()

async def update_role(db: AsyncSession, role_id: int, name: str):
    result = await db.execute(select(Role).filter(Role.id == role_id))
    db_role = result.scalars().first()
    if db_role:
        db_role.name = name
        await db.commit()
        await db.refresh(db_role)
    return db_role

async def delete_role(db: AsyncSession, role_id: int):
    result = await db.execute(select(Role).filter(Role.id == role_id))
    db_role = result.scalars().first()
    if db_role:
        await db.delete(db_role)
        await db.commit()
    return db_role
