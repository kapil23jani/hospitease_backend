from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.claim_item import ClaimItem
from app.schemas.claim_item import ClaimItemCreate, ClaimItemUpdate

async def get_claim_items_by_claim(db: AsyncSession, claim_id: str):
    result = await db.execute(select(ClaimItem).filter(ClaimItem.claim_id == claim_id))
    return result.scalars().all()

async def create_claim_item(db: AsyncSession, claim_id: str, claim_item: ClaimItemCreate):
    db_claim_item = ClaimItem(
        claim_id=claim_id,
        **claim_item.model_dump()
    )
    db.add(db_claim_item)
    await db.commit()
    await db.refresh(db_claim_item)
    return db_claim_item

async def update_claim_item(db: AsyncSession, claim_item_id: str, claim_item: ClaimItemUpdate):
    result = await db.execute(select(ClaimItem).filter(ClaimItem.claim_item_id == claim_item_id))
    db_claim_item = result.scalar_one_or_none()
    if not db_claim_item:
        return None
    for key, value in claim_item.model_dump(exclude_unset=True).items():
        setattr(db_claim_item, key, value)
    await db.commit()
    await db.refresh(db_claim_item)
    return db_claim_item

async def delete_claim_item(db: AsyncSession, claim_item_id: str):
    result = await db.execute(select(ClaimItem).filter(ClaimItem.claim_item_id == claim_item_id))
    db_claim_item = result.scalar_one_or_none()
    if not db_claim_item:
        return None
    await db.delete(db_claim_item)
    await db.commit()
    return True