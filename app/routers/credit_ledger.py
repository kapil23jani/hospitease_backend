from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.credit_ledger import CreditLedgerCreate, CreditLedgerUpdate, CreditLedgerResponse
from app.crud.credit_ledger import get_credit_ledgers, get_credit_ledger, create_credit_ledger, update_credit_ledger, delete_credit_ledger

router = APIRouter(prefix="/credit_ledgers", tags=["Credit Ledgers"])

@router.get("/", response_model=List[CreditLedgerResponse])
async def list_credit_ledgers(db: AsyncSession = Depends(get_db)):
    return await get_credit_ledgers(db)

@router.get("/{credit_id}", response_model=CreditLedgerResponse)
async def read_credit_ledger(credit_id: str, db: AsyncSession = Depends(get_db)):
    credit_ledger = await get_credit_ledger(db, credit_id)
    if not credit_ledger:
        raise HTTPException(status_code=404, detail="Credit ledger not found")
    return credit_ledger

@router.post("/invoice/{invoice_id}", response_model=CreditLedgerResponse)
async def create_new_credit_ledger(invoice_id: str, credit_ledger: CreditLedgerCreate, db: AsyncSession = Depends(get_db)):
    return await create_credit_ledger(db, invoice_id, credit_ledger)

@router.put("/{credit_id}", response_model=CreditLedgerResponse)
async def update_existing_credit_ledger(credit_id: str, credit_ledger: CreditLedgerUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_credit_ledger(db, credit_id, credit_ledger)
    if not updated:
        raise HTTPException(status_code=404, detail="Credit ledger not found")
    return updated

@router.delete("/{credit_id}")
async def delete_existing_credit_ledger(credit_id: str, db: AsyncSession = Depends(get_db)):
    deleted = await delete_credit_ledger(db, credit_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Credit ledger not found")
    return {"ok": True}