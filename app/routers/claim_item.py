from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.claim_item import ClaimItemCreate, ClaimItemUpdate, ClaimItemResponse
from app.crud.claim_item import get_claim_items_by_claim, create_claim_item, update_claim_item, delete_claim_item

router = APIRouter(prefix="/claim_items", tags=["Claim Items"])

@router.get("/insurance_claim/{claim_id}", response_model=List[ClaimItemResponse])
async def list_claim_items_by_claim(claim_id: str, db: AsyncSession = Depends(get_db)):
    return await get_claim_items_by_claim(db, claim_id)

@router.post("/insurance_claim/{claim_id}", response_model=ClaimItemResponse)
async def create_new_claim_item(claim_id: str, claim_item: ClaimItemCreate, db: AsyncSession = Depends(get_db)):
    return await create_claim_item(db, claim_id, claim_item)

@router.put("/{claim_item_id}", response_model=ClaimItemResponse)
async def update_existing_claim_item(claim_item_id: str, claim_item: ClaimItemUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_claim_item(db, claim_item_id, claim_item)
    if not updated:
        raise HTTPException(status_code=404, detail="Claim item not found")
    return updated

@router.delete("/{claim_item_id}")
async def delete_existing_claim_item(claim_item_id: str, db: AsyncSession = Depends(get_db)):
    deleted = await delete_claim_item(db, claim_item_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Claim item not found")
    return {"ok": True}