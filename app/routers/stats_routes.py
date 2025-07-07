from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.stats_crud import get_stats
from app.schemas.stats_schema import StatsResponse

router = APIRouter()

@router.get("/stats", response_model=StatsResponse)
async def fetch_stats(db: AsyncSession = Depends(get_db)):
    return await get_stats(db)
