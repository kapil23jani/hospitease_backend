from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.permission import Permission
from app.schemas.permission import PermissionCreate, PermissionUpdate

async def create_permission(db: AsyncSession, permission: PermissionCreate):
    db_permission = Permission(**permission.dict())
    db.add(db_permission)
    await db.commit()
    await db.refresh(db_permission)
    return db_permission

async def get_permission(db: AsyncSession, permission_id: int):
    result = await db.execute(select(Permission).where(Permission.id == permission_id))
    return result.scalar_one_or_none()

async def get_permissions(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(Permission).offset(skip).limit(limit))
    return result.scalars().all()

async def update_permission(db: AsyncSession, permission_id: int, permission: PermissionUpdate):
    db_permission = await get_permission(db, permission_id)
    if not db_permission:
        return None
    for key, value in permission.dict(exclude_unset=True).items():
        setattr(db_permission, key, value)
    await db.commit()
    await db.refresh(db_permission)
    return db_permission

async def delete_permission(db: AsyncSession, permission_id: int):
    db_permission = await get_permission(db, permission_id)
    if not db_permission:
        return None
    await db.delete(db_permission)
    await db.commit()
    return db_permission