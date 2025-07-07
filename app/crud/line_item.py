from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.line_item import LineItem
from app.schemas.line_item import LineItemCreate, LineItemUpdate

async def get_line_items_by_encounter(db: AsyncSession, encounter_id: str):
    result = await db.execute(select(LineItem).filter(LineItem.encounter_id == encounter_id))
    return result.scalars().all()

async def create_line_item(db: AsyncSession, encounter_id: str, line_item: LineItemCreate):
    db_line_item = LineItem(
        encounter_id=encounter_id,
        **line_item.model_dump()
    )
    db.add(db_line_item)
    await db.commit()
    await db.refresh(db_line_item)
    return db_line_item

async def update_line_item(db: AsyncSession, line_item_id: str, line_item: LineItemUpdate):
    result = await db.execute(select(LineItem).filter(LineItem.line_item_id == line_item_id))
    db_line_item = result.scalar_one_or_none()
    if not db_line_item:
        return None
    for key, value in line_item.model_dump(exclude_unset=True).items():
        setattr(db_line_item, key, value)
    await db.commit()
    await db.refresh(db_line_item)
    return db_line_item

async def delete_line_item(db: AsyncSession, line_item_id: str):
    result = await db.execute(select(LineItem).filter(LineItem.line_item_id == line_item_id))
    db_line_item = result.scalar_one_or_none()
    if not db_line_item:
        return None
    await db.delete(db_line_item)
    await db.commit()
    return True