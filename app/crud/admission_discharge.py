from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update, delete
from app.models.admission_discharge import AdmissionDischarge
from app.schemas.admission_discharge import AdmissionDischargeCreate, AdmissionDischargeUpdate

async def create_admission_discharge(db: AsyncSession, discharge: AdmissionDischargeCreate):
    db_discharge = AdmissionDischarge(**discharge.dict())
    db.add(db_discharge)
    await db.commit()
    await db.refresh(db_discharge)
    return db_discharge

async def get_admission_discharge(db: AsyncSession, discharge_id: int):
    result = await db.execute(select(AdmissionDischarge).where(AdmissionDischarge.id == discharge_id))
    return result.scalar_one_or_none()

async def get_discharges_by_admission_id(db: AsyncSession, admission_id: int):
    result = await db.execute(select(AdmissionDischarge).where(AdmissionDischarge.admission_id == admission_id))
    return result.scalars().all()

async def update_admission_discharge(db: AsyncSession, discharge_id: int, discharge: AdmissionDischargeUpdate):
    await db.execute(
        update(AdmissionDischarge).where(AdmissionDischarge.id == discharge_id).values(**discharge.dict(exclude_unset=True))
    )
    await db.commit()
    return await get_admission_discharge(db, discharge_id)

async def delete_admission_discharge(db: AsyncSession, discharge_id: int):
    await db.execute(delete(AdmissionDischarge).where(AdmissionDischarge.id == discharge_id))
    await db.commit()

async def get_all_discharges(db: AsyncSession):
    result = await db.execute(select(AdmissionDischarge))
    return result.scalars().all()