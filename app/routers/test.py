from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, Query
from fastapi.responses import JSONResponse
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
import boto3
import re
from app.database import get_db
from app.schemas.test import TestResponse
from app.crud.test import create_test, update_test, get_test_by_id, get_tests_by_appointment_id, delete_test, get_tests_by_patient_id
from app.utils.s3 import get_presigned_url

router = APIRouter()

@router.post("/", response_model=TestResponse)
async def create_test_api(
    appointment_id: int = Form(...),
    test_details: str = Form(...),
    status: str = Form(...),
    cost: int = Form(...),
    description: str = Form(...),
    doctor_notes: str = Form(...),
    staff_notes: Optional[str] = Form(None),
    test_date: str = Form(...),
    test_done_date: Optional[str] = Form(None),
    files: Optional[List[UploadFile]] = File(None),
    db: AsyncSession = Depends(get_db),
):
    from app.schemas.test import TestCreate
    test = TestCreate(
        appointment_id=appointment_id,
        test_details=test_details,
        status=status,
        cost=cost,
        description=description,
        doctor_notes=doctor_notes,
        staff_notes=staff_notes,
        test_date=test_date,
        test_done_date=test_done_date,
    )
    return await create_test(db, test, files)

def add_presigned_urls_to_test(test_obj):
    urls = test_obj.tests_docs_urls or []
    if isinstance(urls, str):
        import json
        urls = json.loads(urls)
    presigned_urls = [
        get_presigned_url(url)["presigned_url"] if isinstance(get_presigned_url(url), dict)
        else get_presigned_url(url)
        for url in urls
    ]
    test_obj.tests_docs_presigned_urls = presigned_urls
    return test_obj

@router.get("/", response_model=list[TestResponse])
async def get_tests_by_appointment_id_api(appointment_id: int, db: AsyncSession = Depends(get_db), skip: int = 0, limit: int = 10):
    tests = await get_tests_by_appointment_id(db, appointment_id, skip, limit)
    tests_with_presigned = [add_presigned_urls_to_test(t) for t in tests]
    return tests_with_presigned

@router.get("/presign-url")
def get_presigned_url(file_url: str = Query(...)):
    match = re.match(r"https://([^/.]+)\.s3\.([^/]+)\.amazonaws\.com/(.+)", file_url)
    if not match:
        return JSONResponse({"error": "Invalid file URL"}, status_code=400)
    bucket, region, key = match.groups()
    print("bucket:", bucket, "region:", region, "key:", key)
    s3 = boto3.client(
        "s3",
        region_name=region,
        endpoint_url=f"https://s3.{region}.amazonaws.com"
    )
    presigned_url = s3.generate_presigned_url(
        "get_object",
        Params={"Bucket": bucket, "Key": key},
        ExpiresIn=300
    )
    print("presigned_url:", presigned_url)
    return {"presigned_url": presigned_url}

@router.get("/{test_id}", response_model=TestResponse)
async def get_test_by_id_api(test_id: int, db: AsyncSession = Depends(get_db)):
    test = await get_test_by_id(db, test_id)
    if not test:
        raise HTTPException(status_code=404, detail="Test not found")
    return test

@router.put("/{test_id}", response_model=TestResponse)
async def update_test_api(
    test_id: int,
    appointment_id: int = Form(...),
    test_details: str = Form(...),
    status: str = Form(...),
    cost: int = Form(...),
    description: str = Form(...),
    doctor_notes: str = Form(...),
    staff_notes: Optional[str] = Form(None),
    test_date: str = Form(...),
    test_done_date: Optional[str] = Form(None),
    files: Optional[List[UploadFile]] = File(None),
    db: AsyncSession = Depends(get_db),
):
    from app.schemas.test import TestUpdate
    test = TestUpdate(
        appointment_id=appointment_id,
        test_details=test_details,
        status=status,
        cost=cost,
        description=description,
        doctor_notes=doctor_notes,
        staff_notes=staff_notes,
        test_date=test_date,
        test_done_date=test_done_date,
    )
    updated_test = await update_test(db, test_id, test, files)
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