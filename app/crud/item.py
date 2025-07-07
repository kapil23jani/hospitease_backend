from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.item import Item
from app.schemas.item import ItemCreate, ItemUpdate

async def get_items(db: AsyncSession):
    result = await db.execute(select(Item))
    return result.scalars().all()

async def get_item(db: AsyncSession, item_id: str):
    result = await db.execute(select(Item).filter(Item.item_id == item_id))
    return result.scalar_one_or_none()

async def create_item(db: AsyncSession, item: ItemCreate):
    db_item = Item(**item.model_dump())
    db.add(db_item)
    await db.commit()
    await db.refresh(db_item)
    return db_item

async def update_item(db: AsyncSession, item_id: str, item: ItemUpdate):
    db_item = await get_item(db, item_id)
    if not db_item:
        return None
    for key, value in item.model_dump(exclude_unset=True).items():
        setattr(db_item, key, value)
    await db.commit()
    await db.refresh(db_item)
    return db_item

async def delete_item(db: AsyncSession, item_id: str):
    db_item = await get_item(db, item_id)
    if not db_item:
        return None
    await db.delete(db_item)
    await db.commit()
    return True