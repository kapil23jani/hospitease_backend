from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.insurance_claim import InsuranceClaimCreate, InsuranceClaimUpdate, InsuranceClaimResponse
from app.crud.insurance_claim import get_insurance_claims, get_insurance_claim, create_insurance_claim, update_insurance_claim, delete_insurance_claim

router = APIRouter(prefix="/insurance_claims", tags=["Insurance Claims"])

@router.get("/", response_model=List[InsuranceClaimResponse])
async def list_insurance_claims(db: AsyncSession = Depends(get_db)):
    return await get_insurance_claims(db)

@router.get("/{claim_id}", response_model=InsuranceClaimResponse)
async def read_insurance_claim(claim_id: str, db: AsyncSession = Depends(get_db)):
    claim = await get_insurance_claim(db, claim_id)
    if not claim:
        raise HTTPException(status_code=404, detail="Insurance claim not found")
    return claim

@router.post("/encounter/{encounter_id}", response_model=InsuranceClaimResponse)
async def create_new_insurance_claim(encounter_id: str, claim: InsuranceClaimCreate, db: AsyncSession = Depends(get_db)):
    return await create_insurance_claim(db, encounter_id, claim)

@router.put("/{claim_id}", response_model=InsuranceClaimResponse)
async def update_existing_insurance_claim(claim_id: str, claim: InsuranceClaimUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_insurance_claim(db, claim_id, claim)
    if not updated:
        raise HTTPException(status_code=404, detail="Insurance claim not found")
    return updated

@router.delete("/{claim_id}")
async def delete_existing_insurance_claim(claim_id: str, db: AsyncSession = Depends(get_db)):
    deleted = await delete_insurance_claim(db, claim_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Insurance claim not found")
    return {"ok": True}