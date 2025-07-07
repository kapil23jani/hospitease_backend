from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.ab_claim import ABClaim
from app.schemas.ab_claim import ABClaimCreate, ABClaimUpdate

async def get_ab_claim_by_claim_id(db: AsyncSession, claim_id: str):
    result = await db.execute(select(ABClaim).filter(ABClaim.claim_id == claim_id))
    return result.scalar_one_or_none()

async def create_ab_claim(db: AsyncSession, claim_id: str, ab_claim: ABClaimCreate):
    db_ab_claim = ABClaim(
        claim_id=claim_id,
        **ab_claim.model_dump()
    )
    db.add(db_ab_claim)
    await db.commit()
    await db.refresh(db_ab_claim)
    return db_ab_claim

async def update_ab_claim(db: AsyncSession, ab_claim_id: str, ab_claim: ABClaimUpdate):
    result = await db.execute(select(ABClaim).filter(ABClaim.ab_claim_id == ab_claim_id))
    db_ab_claim = result.scalar_one_or_none()
    if not db_ab_claim:
        return None
    for key, value in ab_claim.model_dump(exclude_unset=True).items():
        setattr(db_ab_claim, key, value)
    await db.commit()
    await db.refresh(db_ab_claim)
    return db_ab_claim