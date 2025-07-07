from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.payment import Payment
from app.schemas.payment import PaymentCreate, PaymentUpdate

async def get_payments(db: AsyncSession):
    result = await db.execute(select(Payment))
    return result.scalars().all()

async def get_payment(db: AsyncSession, payment_id: str):
    result = await db.execute(select(Payment).filter(Payment.payment_id == payment_id))
    return result.scalar_one_or_none()

async def create_payment(db: AsyncSession, invoice_id: str, payment: PaymentCreate):
    db_payment = Payment(
        invoice_id=invoice_id,
        **payment.model_dump()
    )
    db.add(db_payment)
    await db.commit()
    await db.refresh(db_payment)
    return db_payment

async def update_payment(db: AsyncSession, payment_id: str, payment: PaymentUpdate):
    db_payment = await get_payment(db, payment_id)
    if not db_payment:
        return None
    for key, value in payment.model_dump(exclude_unset=True).items():
        setattr(db_payment, key, value)
    await db.commit()
    await db.refresh(db_payment)
    return db_payment

async def delete_payment(db: AsyncSession, payment_id: str):
    db_payment = await get_payment(db, payment_id)
    if not db_payment:
        return None
    await db.delete(db_payment)
    await db.commit()
    return True