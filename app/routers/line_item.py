from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.line_item import LineItemCreate, LineItemUpdate, LineItemResponse
from app.crud.line_item import get_line_items_by_encounter, create_line_item, update_line_item, delete_line_item

router = APIRouter(prefix="/line_items", tags=["Line Items"])

@router.get("/encounter/{encounter_id}", response_model=List[LineItemResponse])
async def list_line_items_by_encounter(encounter_id: str, db: AsyncSession = Depends(get_db)):
    return await get_line_items_by_encounter(db, encounter_id)

@router.post("/encounter/{encounter_id}", response_model=LineItemResponse)
async def create_new_line_item(encounter_id: str, line_item: LineItemCreate, db: AsyncSession = Depends(get_db)):
    return await create_line_item(db, encounter_id, line_item)

@router.put("/{line_item_id}", response_model=LineItemResponse)
async def update_existing_line_item(line_item_id: str, line_item: LineItemUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_line_item(db, line_item_id, line_item)
    if not updated:
        raise HTTPException(status_code=404, detail="Line item not found")
    return updated

@router.delete("/{line_item_id}")
async def delete_existing_line_item(line_item_id: str, db: AsyncSession = Depends(get_db)):
    deleted = await delete_line_item(db, line_item_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Line item not found")
    return {"ok": True}