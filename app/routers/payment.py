from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.payment import PaymentCreate, PaymentUpdate, PaymentResponse
from app.crud.payment import get_payments, get_payment, create_payment, update_payment, delete_payment

router = APIRouter(prefix="/payments", tags=["Payments"])

@router.get("/", response_model=List[PaymentResponse])
async def list_payments(db: AsyncSession = Depends(get_db)):
    return await get_payments(db)

@router.get("/{payment_id}", response_model=PaymentResponse)
async def read_payment(payment_id: str, db: AsyncSession = Depends(get_db)):
    payment = await get_payment(db, payment_id)
    if not payment:
        raise HTTPException(status_code=404, detail="Payment not found")
    return payment

@router.post("/invoice/{invoice_id}", response_model=PaymentResponse)
async def create_new_payment(invoice_id: str, payment: PaymentCreate, db: AsyncSession = Depends(get_db)):
    return await create_payment(db, invoice_id, payment)

@router.put("/{payment_id}", response_model=PaymentResponse)
async def update_existing_payment(payment_id: str, payment: PaymentUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_payment(db, payment_id, payment)
    if not updated:
        raise HTTPException(status_code=404, detail="Payment not found")
    return updated

@router.delete("/{payment_id}")
async def delete_existing_payment(payment_id: str, db: AsyncSession = Depends(get_db)):
    deleted = await delete_payment(db, payment_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Payment not found")
    return {"ok": True}