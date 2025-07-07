from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.insurance_provider import InsuranceProvider
from app.schemas.insurance_provider import InsuranceProviderCreate, InsuranceProviderUpdate

async def get_insurance_providers(db: AsyncSession):
    result = await db.execute(select(InsuranceProvider))
    return result.scalars().all()

async def get_insurance_provider(db: AsyncSession, insurance_id: str):
    result = await db.execute(select(InsuranceProvider).filter(InsuranceProvider.insurance_id == insurance_id))
    return result.scalar_one_or_none()

async def create_insurance_provider(db: AsyncSession, provider: InsuranceProviderCreate):
    db_provider = InsuranceProvider(**provider.model_dump())
    db.add(db_provider)
    await db.commit()
    await db.refresh(db_provider)
    return db_provider

async def update_insurance_provider(db: AsyncSession, insurance_id: str, provider: InsuranceProviderUpdate):
    db_provider = await get_insurance_provider(db, insurance_id)
    if not db_provider:
        return None
    for key, value in provider.model_dump(exclude_unset=True).items():
        setattr(db_provider, key, value)
    await db.commit()
    await db.refresh(db_provider)
    return db_provider

async def delete_insurance_provider(db: AsyncSession, insurance_id: str):
    db_provider = await get_insurance_provider(db, insurance_id)
    if not db_provider:
        return None
    await db.delete(db_provider)
    await db.commit()
    return True