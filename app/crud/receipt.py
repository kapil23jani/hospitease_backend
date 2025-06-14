from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload
from sqlalchemy.future import select
from app.schemas.receipt import Receipt, ReceiptBase, ReceiptCreate, ReceiptLineItem, ReceiptLineItemBase, ReceiptLineItemCreate
from app.models.receipt import Receipt, ReceiptLineItem
from datetime import datetime

async def create_receipt(db: AsyncSession, receipt_create: ReceiptCreate):
    current_time = datetime.utcnow().replace(tzinfo=None)
    receipt = Receipt(**receipt_create.dict(exclude={"line_items"}))
    receipt.created_at = current_time 
    receipt.updated_at = current_time

    db.add(receipt)
    await db.flush()
    
    for item in receipt_create.line_items:
        db.add(ReceiptLineItem(**item.dict(), receipt_id=receipt.id))
    
    await db.commit()
    
    result = await db.execute(
        select(Receipt).options(selectinload(Receipt.line_items)).where(Receipt.id == receipt.id)
    )
    return result.scalar_one()

async def update_receipt(db: AsyncSession, receipt_id: int, receipt_update: ReceiptCreate):
    result = await db.execute(
        select(Receipt)
        .options(selectinload(Receipt.line_items))
        .where(Receipt.id == receipt_id)
    )
    receipt = result.scalar_one_or_none()
    if not receipt:
        return None
    
    current_time = datetime.utcnow().replace(tzinfo=None) 
    receipt.updated_at = current_time

    for key, value in receipt_update.dict(exclude={"line_items"}).items():
        setattr(receipt, key, value)

    for item in receipt.line_items:
        await db.delete(item)
    
    for item in receipt_update.line_items:
        db.add(ReceiptLineItem(**item.dict(), receipt_id=receipt.id))
    
    await db.commit()
    
    result = await db.execute(
        select(Receipt)
        .options(selectinload(Receipt.line_items))
        .where(Receipt.id == receipt.id)
    )
    return result.scalar_one()

async def get_receipts(db: AsyncSession, skip=0, limit=100):
    result = await db.execute(
        select(Receipt)
        .options(selectinload(Receipt.line_items))
        .offset(skip)
        .limit(limit)
    )
    return result.scalars().all()

async def get_receipt(db: AsyncSession, receipt_id: int):
    result = await db.execute(
        select(Receipt)
        .options(selectinload(Receipt.line_items))
        .where(Receipt.id == receipt_id)
    )
    return result.scalars().first()

async def delete_receipt(db: AsyncSession, receipt_id: int):
    receipt = await get_receipt(db, receipt_id)
    if receipt:
        await db.delete(receipt)
        await db.commit()
    return {"message": "Receipt deleted successfully"}

async def get_receipts_by_patient(db: AsyncSession, patient_id: int):
    result = await db.execute(
        select(Receipt)
        .options(selectinload(Receipt.line_items))
        .where(Receipt.patient_id == patient_id)
    )
    return result.scalars().all()

async def get_receipts_by_hospital(db: AsyncSession, hospital_id: int):
    result = await db.execute(
        select(Receipt)
        .options(selectinload(Receipt.line_items))
        .where(Receipt.hospital_id == hospital_id)
    )
    return result.scalars().all()
