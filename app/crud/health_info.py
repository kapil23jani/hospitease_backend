from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from fastapi import HTTPException
from app.models.health_info import HealthInfo
from app.models.appointment import Appointment
from app.schemas.health_info import HealthInfoCreate, HealthInfoUpdate

async def create_health_info(db: AsyncSession, health_info_data: HealthInfoCreate):
    # Check if appointment exists
    result = await db.execute(select(Appointment).filter(Appointment.id == health_info_data.appointment_id))
    appointment = result.scalars().first()
    
    if not appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")

    # Check if health info already exists
    result = await db.execute(select(HealthInfo).filter(HealthInfo.appointment_id == health_info_data.appointment_id))
    existing_health_info = result.scalars().first()
    
    if existing_health_info:
        raise HTTPException(status_code=400, detail="Health info already exists for this appointment")

    health_info = HealthInfo(**health_info_data.dict())
    db.add(health_info)
    await db.commit()
    await db.refresh(health_info)
    return health_info

async def get_health_info_by_appointment(db: AsyncSession, id: int):
    result = await db.execute(select(HealthInfo).filter(HealthInfo.id == id))
    health_info = result.scalars().first()
    
    if not health_info:
        raise HTTPException(status_code=404, detail="Health info not found")
    
    return health_info

async def get_health_info_by_appointment_id(db: AsyncSession, appointment_id: int):
    result = await db.execute(select(HealthInfo).filter(HealthInfo.appointment_id == appointment_id))
    health_info = result.scalars().first()
    
    return health_info

async def update_health_info(db: AsyncSession, appointment_id: int, update_data: HealthInfoUpdate):
    result = await db.execute(select(HealthInfo).filter(HealthInfo.id == appointment_id))
    health_info = result.scalars().first()
    
    if not health_info:
        raise HTTPException(status_code=404, detail="Health info not found")

    for key, value in update_data.dict(exclude_unset=True).items():
        setattr(health_info, key, value)

    await db.commit()
    await db.refresh(health_info)
    return health_info

async def delete_health_info(db: AsyncSession, appointment_id: int):
    result = await db.execute(select(HealthInfo).filter(HealthInfo.appointment_id == appointment_id))
    health_info = result.scalars().first()
    
    if not health_info:
        raise HTTPException(status_code=404, detail="Health info not found")

    await db.delete(health_info)
    await db.commit()
    return {"message": "Health info deleted successfully"}
