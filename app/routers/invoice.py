from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.invoice import InvoiceCreate, InvoiceUpdate, InvoiceResponse
from app.crud.invoice import get_invoices, get_invoice, create_invoice, update_invoice, delete_invoice

router = APIRouter(prefix="/invoices", tags=["Invoices"])

@router.get("/", response_model=List[InvoiceResponse])
async def list_invoices(db: AsyncSession = Depends(get_db)):
    return await get_invoices(db)

@router.get("/{invoice_id}", response_model=InvoiceResponse)
async def read_invoice(invoice_id: str, db: AsyncSession = Depends(get_db)):
    invoice = await get_invoice(db, invoice_id)
    if not invoice:
        raise HTTPException(status_code=404, detail="Invoice not found")
    return invoice

@router.post("/encounter/{encounter_id}", response_model=InvoiceResponse)
async def create_new_invoice(encounter_id: str, invoice: InvoiceCreate, db: AsyncSession = Depends(get_db)):
    return await create_invoice(db, encounter_id, invoice)

@router.put("/{invoice_id}", response_model=InvoiceResponse)
async def update_existing_invoice(invoice_id: str, invoice: InvoiceUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_invoice(db, invoice_id, invoice)
    if not updated:
        raise HTTPException(status_code=404, detail="Invoice not found")
    return updated

@router.delete("/{invoice_id}")
async def delete_existing_invoice(invoice_id: str, db: AsyncSession = Depends(get_db)):
    deleted = await delete_invoice(db, invoice_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Invoice not found")
    return {"ok": True}