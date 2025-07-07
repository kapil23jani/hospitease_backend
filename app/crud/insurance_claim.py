from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.insurance_claim import InsuranceClaim
from app.schemas.insurance_claim import InsuranceClaimCreate, InsuranceClaimUpdate

async def get_insurance_claims(db: AsyncSession):
    result = await db.execute(select(InsuranceClaim))
    return result.scalars().all()

async def get_insurance_claim(db: AsyncSession, claim_id: str):
    result = await db.execute(select(InsuranceClaim).filter(InsuranceClaim.claim_id == claim_id))
    return result.scalar_one_or_none()

async def create_insurance_claim(db: AsyncSession, encounter_id: str, claim: InsuranceClaimCreate):
    db_claim = InsuranceClaim(
        encounter_id=encounter_id,
        **claim.model_dump()
    )
    db.add(db_claim)
    await db.commit()
    await db.refresh(db_claim)
    return db_claim

async def update_insurance_claim(db: AsyncSession, claim_id: str, claim: InsuranceClaimUpdate):
    db_claim = await get_insurance_claim(db, claim_id)
    if not db_claim:
        return None
    for key, value in claim.model_dump(exclude_unset=True).items():
        setattr(db_claim, key, value)
    await db.commit()
    await db.refresh(db_claim)
    return db_claim

async def delete_insurance_claim(db: AsyncSession, claim_id: str):
    db_claim = await get_insurance_claim(db, claim_id)
    if not db_claim:
        return None
    await db.delete(db_claim)
    await db.commit()
    return True