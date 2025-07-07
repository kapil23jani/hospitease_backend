from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.credit_ledger import CreditLedger
from app.schemas.credit_ledger import CreditLedgerCreate, CreditLedgerUpdate

async def get_credit_ledgers(db: AsyncSession):
    result = await db.execute(select(CreditLedger))
    return result.scalars().all()

async def get_credit_ledger(db: AsyncSession, credit_id: str):
    result = await db.execute(select(CreditLedger).filter(CreditLedger.credit_id == credit_id))
    return result.scalar_one_or_none()

async def create_credit_ledger(db: AsyncSession, invoice_id: str, credit_ledger: CreditLedgerCreate):
    db_credit_ledger = CreditLedger(
        invoice_id=invoice_id,
        **credit_ledger.model_dump()
    )
    db.add(db_credit_ledger)
    await db.commit()
    await db.refresh(db_credit_ledger)
    return db_credit_ledger

async def update_credit_ledger(db: AsyncSession, credit_id: str, credit_ledger: CreditLedgerUpdate):
    db_credit_ledger = await get_credit_ledger(db, credit_id)
    if not db_credit_ledger:
        return None
    for key, value in credit_ledger.model_dump(exclude_unset=True).items():
        setattr(db_credit_ledger, key, value)
    await db.commit()
    await db.refresh(db_credit_ledger)
    return db_credit_ledger

async def delete_credit_ledger(db: AsyncSession, credit_id: str):
    db_credit_ledger = await get_credit_ledger(db, credit_id)
    if not db_credit_ledger:
        return None
    await db.delete(db_credit_ledger)
    await db.commit()
    return True