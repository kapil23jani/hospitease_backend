from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.schemas.hospital_payment import (
    HospitalPaymentCreate, HospitalPaymentUpdate, HospitalPaymentResponse
)
from app.crud.hospital_payment import (
    create_hospital_payment, get_hospital_payments, update_hospital_payment, delete_hospital_payment
)

from app.schemas.hospital_payment import HospitalPaymentWithHospitalResponse
from app.crud.hospital_payment import get_all_payments_with_hospital


from app.database import get_db

router = APIRouter(prefix="", tags=["Hospital Payments"])

@router.post("/", response_model=HospitalPaymentResponse)
async def create_payment(payment: HospitalPaymentCreate, db: AsyncSession = Depends(get_db)):
    return await create_hospital_payment(db, payment)

@router.get("/all", response_model=List[HospitalPaymentWithHospitalResponse])
async def list_all_payments(db: AsyncSession = Depends(get_db)):
    payments = await get_all_payments_with_hospital(db)
    response = []
    for p in payments:
        response.append(HospitalPaymentWithHospitalResponse(
            transaction_id=f"#TRX-{str(p.id).zfill(3)}",
            hospital={"id": p.hospital.id, "name": p.hospital.name} if p.hospital else None,
            date=p.date,
            payment_type=p.payment_method,
            amount=float(p.amount),
            status=p.status,
            id=p.id
        ))
    return response

@router.get("/{hospital_id}", response_model=List[HospitalPaymentResponse])
async def list_payments(hospital_id: int, db: AsyncSession = Depends(get_db)):
    return await get_hospital_payments(db, hospital_id)

@router.put("/{payment_id}", response_model=HospitalPaymentResponse)
async def update_payment(payment_id: int, payment: HospitalPaymentUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_hospital_payment(db, payment_id, payment)
    if not updated:
        raise HTTPException(status_code=404, detail="Payment not found")
    return updated

@router.delete("/{payment_id}", response_model=HospitalPaymentResponse)
async def delete_payment(payment_id: int, db: AsyncSession = Depends(get_db)):
    deleted = await delete_hospital_payment(db, payment_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Payment not found")
    return deleted