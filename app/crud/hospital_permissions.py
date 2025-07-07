from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.hospital_permissions import HospitalPermission
from app.schemas.hospital_perimissions import HospitalPermissionCreate
from app.schemas.hospital_perimissions import HospitalPermissionBulkCreate, HospitalPermissionBulkCreate
from sqlalchemy import delete

async def add_permissions_to_hospital(db: AsyncSession, hp: HospitalPermissionBulkCreate):
    # Delete all previous permissions for this hospital
    await db.execute(
        delete(HospitalPermission).where(HospitalPermission.hospital_id == hp.hospital_id)
    )
    await db.commit()

    # Add new permissions
    objs = [
        HospitalPermission(hospital_id=hp.hospital_id, permission_id=pid)
        for pid in hp.permission_ids
    ]
    db.add_all(objs)
    await db.commit()
    for obj in objs:
        await db.refresh(obj)
    return objs

async def get_permissions_for_hospital(db: AsyncSession, hospital_id: int):
    result = await db.execute(
        select(HospitalPermission).where(HospitalPermission.hospital_id == hospital_id)
    )
    return result.scalars().all()

async def update_hospital_permission(
    db: AsyncSession, hp_id: int, hp_update: HospitalPermissionCreate
):
    db_hp = await db.get(HospitalPermission, hp_id)
    if not db_hp:
        return None
    for key, value in hp_update.dict(exclude_unset=True).items():
        setattr(db_hp, key, value)
    await db.commit()
    await db.refresh(db_hp)
    return db_hp