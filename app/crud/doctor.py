from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.exc import NoResultFound
from app.models.doctor import Doctor
from app.schemas.doctor import DoctorCreate, DoctorUpdate

async def create_doctor(db: AsyncSession, doctor: DoctorCreate):
    db_doctor = Doctor(**doctor.dict())
    db.add(db_doctor)
    await db.commit()
    await db.refresh(db_doctor)
    return db_doctor

async def get_doctors(db: AsyncSession, skip: int = 0, limit: int = 10):
    result = await db.execute(select(Doctor).offset(skip).limit(limit))
    return result.scalars().all()

async def get_doctor_by_id(db: AsyncSession, doctor_id: int):
    result = await db.execute(select(Doctor).where(Doctor.id == doctor_id))
    doctor = result.scalar_one_or_none()
    return doctor

async def update_doctor(db: AsyncSession, doctor_id: int, doctor: DoctorUpdate):
    result = await db.execute(select(Doctor).where(Doctor.id == doctor_id))
    db_doctor = result.scalar_one_or_none()

    if not db_doctor:
        return None

    for key, value in doctor.dict(exclude_unset=True).items():
        setattr(db_doctor, key, value)

    await db.commit()
    await db.refresh(db_doctor)
    return db_doctor

async def delete_doctor(db: AsyncSession, doctor_id: int):
    result = await db.execute(select(Doctor).where(Doctor.id == doctor_id))
    db_doctor = result.scalar_one_or_none()

    if db_doctor:
        await db.delete(db_doctor)
        await db.commit()
        return True
    return False
