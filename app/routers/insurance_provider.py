from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.insurance_provider import InsuranceProviderCreate, InsuranceProviderUpdate, InsuranceProviderResponse
from app.crud.insurance_provider import get_insurance_providers, get_insurance_provider, create_insurance_provider, update_insurance_provider, delete_insurance_provider

router = APIRouter(prefix="/insurance_providers", tags=["Insurance Providers"])

@router.get("/", response_model=List[InsuranceProviderResponse])
async def list_insurance_providers(db: AsyncSession = Depends(get_db)):
    return await get_insurance_providers(db)

@router.get("/{insurance_id}", response_model=InsuranceProviderResponse)
async def read_insurance_provider(insurance_id: str, db: AsyncSession = Depends(get_db)):
    provider = await get_insurance_provider(db, insurance_id)
    if not provider:
        raise HTTPException(status_code=404, detail="Insurance provider not found")
    return provider

@router.post("/", response_model=InsuranceProviderResponse)
async def create_new_insurance_provider(provider: InsuranceProviderCreate, db: AsyncSession = Depends(get_db)):
    return await create_insurance_provider(db, provider)

@router.put("/{insurance_id}", response_model=InsuranceProviderResponse)
async def update_existing_insurance_provider(insurance_id: str, provider: InsuranceProviderUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_insurance_provider(db, insurance_id, provider)
    if not updated:
        raise HTTPException(status_code=404, detail="Insurance provider not found")
    return updated

@router.delete("/{insurance_id}")
async def delete_existing_insurance_provider(insurance_id: str, db: AsyncSession = Depends(get_db)):
    deleted = await delete_insurance_provider(db, insurance_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Insurance provider not found")
    return {"ok": True}