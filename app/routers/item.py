from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.item import ItemCreate, ItemUpdate, ItemResponse
from app.crud.item import get_items, get_item, create_item, update_item, delete_item

router = APIRouter(prefix="/items", tags=["Items"])

@router.get("/", response_model=List[ItemResponse])
async def list_items(db: AsyncSession = Depends(get_db)):
    return await get_items(db)

@router.get("/{item_id}", response_model=ItemResponse)
async def read_item(item_id: str, db: AsyncSession = Depends(get_db)):
    item = await get_item(db, item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item

@router.post("/", response_model=ItemResponse)
async def create_new_item(item: ItemCreate, db: AsyncSession = Depends(get_db)):
    return await create_item(db, item)

@router.put("/{item_id}", response_model=ItemResponse)
async def update_existing_item(item_id: str, item: ItemUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_item(db, item_id, item)
    if not updated:
        raise HTTPException(status_code=404, detail="Item not found")
    return updated

@router.delete("/{item_id}")
async def delete_existing_item(item_id: str, db: AsyncSession = Depends(get_db)):
    deleted = await delete_item(db, item_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"ok": True}