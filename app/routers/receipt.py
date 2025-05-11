from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.schemas.receipt import Receipt, ReceiptBase, ReceiptCreate, ReceiptLineItemBase, ReceiptLineItem, ReceiptLineItemCreate
from app.database import get_db
from app.crud import receipt

router = APIRouter()

@router.post("/", response_model=Receipt)
async def create(receipt_data: ReceiptCreate, db: AsyncSession = Depends(get_db)):
    return await receipt.create_receipt(db, receipt_data)

@router.get("/", response_model=List[Receipt])
async def list_receipts(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await receipt.get_receipts(db, skip, limit)

@router.get("/{receipt_id}", response_model=Receipt)
async def get_one(receipt_id: int, db: AsyncSession = Depends(get_db)):
    receipt = await receipt.get_receipt(db, receipt_id)
    if not receipt:
        raise HTTPException(status_code=404, detail="Receipt not found")
    return receipt

@router.delete("/{receipt_id}")
async def delete(receipt_id: int, db: AsyncSession = Depends(get_db)):
    receipt_obj = await receipt.delete_receipt(db, receipt_id)
    if not receipt_obj:
        raise HTTPException(status_code=404, detail="Receipt not found")
    return receipt_obj

@router.put("/{receipt_id}", response_model=Receipt)
async def update(receipt_id: int, updated_data: ReceiptCreate, db: AsyncSession = Depends(get_db)):
    updated = await receipt.update_receipt(db, receipt_id, updated_data)
    if not updated:
        raise HTTPException(status_code=404, detail="Receipt not found")
    return updated

@router.get("/patient/{patient_id}", response_model=list[Receipt])
async def get_receipts_for_patient(patient_id: int, db: AsyncSession = Depends(get_db)):
    return await receipt.get_receipts_by_patient(db, patient_id)

@router.get("/hospital/{hospital_id}", response_model=list[Receipt])
async def read_receipts_by_hospital(
    hospital_id: int,
    db: AsyncSession = Depends(get_db),
):
    return await receipt.get_receipts_by_hospital(db, hospital_id)