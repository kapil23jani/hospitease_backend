from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List, Optional
from app.models.test import Test
from app.schemas.test import TestCreate, TestUpdate
from app.models.appointment import Appointment
from app.models.patient import Patient
from app.utils.s3 import upload_file_to_s3
from fastapi import UploadFile, File, Form, Depends
from fastapi import APIRouter, Depends
from app.schemas.test import TestResponse
from app.database import get_db
import json

router = APIRouter()

async def create_test(db: AsyncSession, test: TestCreate, files: list = None):
    doc_urls = []
    if files:
        for file in files:
            file_obj = await file.read()
            from io import BytesIO
            url = upload_file_to_s3(BytesIO(file_obj), file.filename)
            doc_urls.append(url)

    new_test = Test(
        appointment_id=test.appointment_id,
        test_details=test.test_details,
        status=test.status,
        cost=test.cost,
        description=test.description,
        doctor_notes=test.doctor_notes,
        staff_notes=test.staff_notes,
        test_date=test.test_date,
        test_done_date=test.test_done_date,
        tests_docs_urls=doc_urls
    )
    db.add(new_test)
    await db.commit()
    await db.refresh(new_test)
    return new_test

async def get_tests_by_appointment_id(db: AsyncSession, appointment_id: int, skip: int = 0, limit: int = 10) -> List[Test]:
    query = select(Test).where(Test.appointment_id == appointment_id).offset(skip).limit(limit)
    result = await db.execute(query)
    return result.scalars().all()

async def get_test_by_id(db: AsyncSession, test_id: int) -> Optional[Test]:
    query = select(Test).where(Test.id == test_id)
    result = await db.execute(query)
    return result.scalars().first()

async def update_test(db: AsyncSession, test_id: int, test_data: TestUpdate, files: list = None):
    query = select(Test).where(Test.id == test_id)
    result = await db.execute(query)
    db_test = result.scalars().first()

    if not db_test:
        return None

    for key, value in test_data.dict(exclude_unset=True).items():
        setattr(db_test, key, value)

    if files:
        doc_urls = db_test.tests_docs_urls or []
        for file in files:
            file_obj = await file.read()
            from io import BytesIO
            url = upload_file_to_s3(BytesIO(file_obj), file.filename)
            doc_urls.append(url)
        db_test.tests_docs_urls = doc_urls

    db.add(db_test)
    await db.commit()
    await db.refresh(db_test)
    
    return db_test

async def delete_test(db: AsyncSession, test_id: int):
    query = select(Test).where(Test.id == test_id)
    result = await db.execute(query)
    db_test = result.scalars().first()

    if not db_test:
        return None

    await db.delete(db_test)
    await db.commit()
    return db_test

async def get_tests_by_patient_id(db: AsyncSession, patient_id: int, skip: int = 0, limit: int = 100) -> List[Test]:
    query = (
        select(Test)
        .join(Appointment, Test.appointment_id == Appointment.id)
        .where(Appointment.patient_id == patient_id)
        .offset(skip)
        .limit(limit)
    )
    result = await db.execute(query)
    return result.scalars().all()

def ensure_list(obj):
    if isinstance(obj.tests_docs_urls, str):
        obj.tests_docs_urls = json.loads(obj.tests_docs_urls)
    return obj