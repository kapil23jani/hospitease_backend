from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.database import get_db
from app.schemas.admission_test import AdmissionTestCreate, AdmissionTestUpdate, AdmissionTestOut
from app.crud.admission_test import (
    create_admission_test, get_admission_test, get_all_admission_tests, update_admission_test, delete_admission_test, get_tests_by_admission_id
)

router = APIRouter(prefix="/admission-tests", tags=["Admission Tests"])

@router.post("/", response_model=AdmissionTestOut)
async def create_admission_test_route(test: AdmissionTestCreate, db: AsyncSession = Depends(get_db)):
    return await create_admission_test(db, test)

@router.get("/{test_id}", response_model=AdmissionTestOut)
async def read_admission_test(test_id: int, db: AsyncSession = Depends(get_db)):
    db_test = await get_admission_test(db, test_id)
    if not db_test:
        raise HTTPException(status_code=404, detail="Admission test not found")
    return db_test

@router.get("/", response_model=List[AdmissionTestOut])
async def read_all_admission_tests(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    return await get_all_admission_tests(db, skip, limit)

@router.put("/{test_id}", response_model=AdmissionTestOut)
async def update_admission_test_route(test_id: int, test: AdmissionTestUpdate, db: AsyncSession = Depends(get_db)):
    return await update_admission_test(db, test_id, test)

@router.delete("/{test_id}")
async def delete_admission_test_route(test_id: int, db: AsyncSession = Depends(get_db)):
    await delete_admission_test(db, test_id)
    return {"ok": True}

@router.get("/by-admission/{admission_id}", response_model=List[AdmissionTestOut])
async def fetch_tests_by_admission(
    admission_id: int,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db)
):
    tests = await get_tests_by_admission_id(db, admission_id, skip, limit)
    if not tests:
        raise HTTPException(status_code=404, detail="No tests found for this admission")
    return tests