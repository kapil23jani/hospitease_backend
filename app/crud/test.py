from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List, Optional
from app.models.test import Test
from app.schemas.test import TestCreate, TestUpdate
from app.models.appointment import Appointment
from app.models.patient import Patient

async def create_test(db: AsyncSession, test: TestCreate):
    new_test = Test(
        appointment_id=test.appointment_id,
        test_details=test.test_details,
        status=test.status,
        cost=test.cost,
        description=test.description,
        doctor_notes=test.doctor_notes,
        staff_notes=test.staff_notes,
        test_date=test.test_date,
        test_done_date=test.test_done_date,
    )
    db.add(new_test)
    await db.commit()
    await db.refresh(new_test)
    return new_test

async def get_tests_by_appointment_id(db: AsyncSession, appointment_id: int, skip: int = 0, limit: int = 10) -> List[Test]:
    query = select(Test).where(Test.appointment_id == appointment_id).offset(skip).limit(limit)
    result = await db.execute(query)
    return result.scalars().all()

async def get_test_by_id(db: AsyncSession, test_id: int) -> Optional[Test]:
    query = select(Test).where(Test.id == test_id)
    result = await db.execute(query)
    return result.scalars().first()

async def update_test(db: AsyncSession, test_id: int, test_data: TestUpdate):
    query = select(Test).where(Test.id == test_id)
    result = await db.execute(query)
    db_test = result.scalars().first()

    if not db_test:
        return None

    for key, value in test_data.dict(exclude_unset=True).items():
        setattr(db_test, key, value)

    db.add(db_test)
    await db.commit()
    await db.refresh(db_test)
    
    return db_test

async def delete_test(db: AsyncSession, test_id: int):
    query = select(Test).where(Test.id == test_id)
    result = await db.execute(query)
    db_test = result.scalars().first()

    if not db_test:
        return None

    await db.delete(db_test)
    await db.commit()
    return db_test

async def get_tests_by_patient_id(db: AsyncSession, patient_id: int, skip: int = 0, limit: int = 100) -> List[Test]:
    query = (
        select(Test)
        .join(Appointment, Test.appointment_id == Appointment.id)
        .where(Appointment.patient_id == patient_id)
        .offset(skip)
        .limit(limit)
    )
    result = await db.execute(query)
    return result.scalars().all()