from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.invoice import Invoice
from app.schemas.invoice import InvoiceCreate, InvoiceUpdate

async def get_invoices(db: AsyncSession):
    result = await db.execute(select(Invoice))
    return result.scalars().all()

async def get_invoice(db: AsyncSession, invoice_id: str):
    result = await db.execute(select(Invoice).filter(Invoice.invoice_id == invoice_id))
    return result.scalar_one_or_none()

async def create_invoice(db: AsyncSession, encounter_id: str, invoice: InvoiceCreate):
    db_invoice = Invoice(
        encounter_id=encounter_id,
        **invoice.model_dump()
    )
    db.add(db_invoice)
    await db.commit()
    await db.refresh(db_invoice)
    return db_invoice

async def update_invoice(db: AsyncSession, invoice_id: str, invoice: InvoiceUpdate):
    db_invoice = await get_invoice(db, invoice_id)
    if not db_invoice:
        return None
    for key, value in invoice.model_dump(exclude_unset=True).items():
        setattr(db_invoice, key, value)
    await db.commit()
    await db.refresh(db_invoice)
    return db_invoice

async def delete_invoice(db: AsyncSession, invoice_id: str):
    db_invoice = await get_invoice(db, invoice_id)
    if not db_invoice:
        return None
    await db.delete(db_invoice)
    await db.commit()
    return True