from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.admission_diet import AdmissionDietCreate, AdmissionDietUpdate, AdmissionDietOut
from app.crud.admission_diet import (
    create_admission_diet, get_admission_diet, get_all_admission_diets, update_admission_diet, delete_admission_diet
)
from app.crud.admission_diet import get_diets_by_admission_id

router = APIRouter(prefix="/admission-diets", tags=["Admission Diets"])

@router.post("/", response_model=AdmissionDietOut)
async def create_admission_diet_route(diet: AdmissionDietCreate, db: AsyncSession = Depends(get_db)):
    return await create_admission_diet(db, diet)

@router.get("/{diet_id}", response_model=AdmissionDietOut)
async def read_admission_diet(diet_id: int, db: AsyncSession = Depends(get_db)):
    db_diet = await get_admission_diet(db, diet_id)
    if not db_diet:
        raise HTTPException(status_code=404, detail="Admission diet not found")
    return db_diet

@router.get("/", response_model=List[AdmissionDietOut])
async def read_all_admission_diets(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_all_admission_diets(db, skip, limit)

@router.put("/{diet_id}", response_model=AdmissionDietOut)
async def update_admission_diet_route(diet_id: int, diet: AdmissionDietUpdate, db: AsyncSession = Depends(get_db)):
    return await update_admission_diet(db, diet_id, diet)

@router.delete("/{diet_id}")
async def delete_admission_diet_route(diet_id: int, db: AsyncSession = Depends(get_db)):
    await delete_admission_diet(db, diet_id)
    return {"ok": True}

@router.get("/by-admission/{admission_id}", response_model=List[AdmissionDietOut])
async def fetch_diets_by_admission(
    admission_id: int,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db)
):
    diets = await get_diets_by_admission_id(db, admission_id, skip, limit)
    if not diets:
        raise HTTPException(status_code=404, detail="No diets found for this admission")
    return diets