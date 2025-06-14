from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.hospital_payment import HospitalPayment
from app.schemas.hospital_payment import HospitalPaymentCreate, HospitalPaymentUpdate
from sqlalchemy.orm import selectinload

async def create_hospital_payment(db: AsyncSession, payment: HospitalPaymentCreate):
    db_payment = HospitalPayment(**payment.dict())
    db.add(db_payment)
    await db.commit()
    await db.refresh(db_payment)
    return db_payment

async def get_hospital_payments(db: AsyncSession, hospital_id: int):
    result = await db.execute(
        select(HospitalPayment).where(HospitalPayment.hospital_id == hospital_id)
    )
    return result.scalars().all()

async def update_hospital_payment(db: AsyncSession, payment_id: int, payment: HospitalPaymentUpdate):
    db_payment = await db.get(HospitalPayment, payment_id)
    if not db_payment:
        return None
    for key, value in payment.dict(exclude_unset=True).items():
        setattr(db_payment, key, value)
    await db.commit()
    await db.refresh(db_payment)
    return db_payment

async def delete_hospital_payment(db: AsyncSession, payment_id: int):
    db_payment = await db.get(HospitalPayment, payment_id)
    if not db_payment:
        return None
    await db.delete(db_payment)
    await db.commit()
    return db_payment


async def get_all_payments_with_hospital(db: AsyncSession):
    result = await db.execute(
        select(HospitalPayment)
        .options(selectinload(HospitalPayment.hospital))
    )
    payments = result.scalars().all()
    return payments