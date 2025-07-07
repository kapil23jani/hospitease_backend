from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.ab_claim import ABClaimCreate, ABClaimUpdate, ABClaimResponse
from app.crud.ab_claim import get_ab_claim_by_claim_id, create_ab_claim, update_ab_claim

router = APIRouter(prefix="/ab_claims", tags=["AB Claims"])

@router.get("/insurance_claim/{claim_id}", response_model=ABClaimResponse)
async def get_ab_claim(claim_id: str, db: AsyncSession = Depends(get_db)):
    ab_claim = await get_ab_claim_by_claim_id(db, claim_id)
    if not ab_claim:
        raise HTTPException(status_code=404, detail="AB Claim not found")
    return ab_claim

@router.post("/insurance_claim/{claim_id}", response_model=ABClaimResponse)
async def create_new_ab_claim(claim_id: str, ab_claim: ABClaimCreate, db: AsyncSession = Depends(get_db)):
    return await create_ab_claim(db, claim_id, ab_claim)

@router.put("/{ab_claim_id}", response_model=ABClaimResponse)
async def update_existing_ab_claim(ab_claim_id: str, ab_claim: ABClaimUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_ab_claim(db, ab_claim_id, ab_claim)
    if not updated:
        raise HTTPException(status_code=404, detail="AB Claim not found")
    return updated