from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app import crud, schemas
from app.schemas.test import TestBase, TestCreate, TestResponse, TestUpdate
from app.crud.test import create_test, update_test, get_test_by_id, get_tests_by_appointment_id, delete_test, get_tests_by_patient_id

router = APIRouter()

@router.post("/", response_model=TestResponse)
async def create_test_api(test: TestCreate, db: AsyncSession = Depends(get_db)):
    return await create_test(db, test)

@router.get("/", response_model=list[TestResponse])
async def get_tests_by_appointment_id_api(appointment_id: int, db: AsyncSession = Depends(get_db), skip: int = 0, limit: int = 10):
    return await get_tests_by_appointment_id(db, appointment_id, skip, limit)

@router.get("/{test_id}", response_model=TestResponse)
async def get_test_by_id_api(test_id: int, db: AsyncSession = Depends(get_db)):
    test = await get_test_by_id(db, test_id)
    if not test:
        raise HTTPException(status_code=404, detail="Test not found")
    return test

@router.put("/{test_id}", response_model=TestResponse)
async def update_test_api(test_id: int, test: TestUpdate, db: AsyncSession = Depends(get_db)):
    updated_test = await update_test(db, test_id, test)
    if not updated_test:
        raise HTTPException(status_code=404, detail="Test not found")
    return updated_test

@router.delete("/{test_id}")
async def delete_test_api(test_id: int, db: AsyncSession = Depends(get_db)):
    deleted_test = await delete_test(db, test_id)
    if not deleted_test:
        raise HTTPException(status_code=404, detail="Test not found")
    return {"message": "Test deleted successfully"}

@router.get("/patients/{patient_id}/tests", response_model=list[TestResponse])
async def fetch_patient_tests(patient_id: int, db: AsyncSession = Depends(get_db)):
    return await get_tests_by_patient_id(db, patient_id)