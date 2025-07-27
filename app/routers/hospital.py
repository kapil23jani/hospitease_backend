from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, Query
from fastapi.responses import JSONResponse
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from sqlalchemy.orm import Session
import boto3
import re
import os

from app.database import get_db
from app.schemas.hospital import HospitalCreate, HospitalUpdate, HospitalResponse
from app.crud.hospital import create_hospital, get_hospital, get_hospitals, delete_hospital, update_hospital
from app.utils.s3 import upload_logo_to_s3

router = APIRouter()

@router.post("/", response_model=HospitalResponse)
async def create_hospital_route(hospital: HospitalCreate, db: Session = Depends(get_db)):
    return await create_hospital(db, hospital)

@router.get("/", response_model=List[HospitalResponse])
async def get_all_hospitals_route(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    hospitals = await get_hospitals(db, skip, limit)
    for hospital in hospitals:
        if hospital.logo_url:
            hospital.presigned_logo_url = generate_presigned_logo_url(hospital.logo_url)
        else:
            hospital.presigned_logo_url = None
    return hospitals

@router.get("/presign-logo")
def get_presigned_logo(file_url: str = Query(...)):
    match = re.match(r"https://([^/.]+)\.s3\.([^/]+)\.amazonaws\.com/(.+)", file_url)
    if not match:
        return JSONResponse({"error": "Invalid file URL"}, status_code=400)
    bucket, region, key = match.groups()
    s3 = boto3.client(
        "s3",
        region_name=region,
        aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
        aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
    )
    presigned_url = s3.generate_presigned_url(
        "get_object",
        Params={
            "Bucket": bucket,
            "Key": key,
            "ResponseContentDisposition": "inline"
        },
        ExpiresIn=300
    )
    return {"presigned_url": presigned_url}

@router.get("/{hospital_id}", response_model=HospitalResponse)
async def get_hospital_route(hospital_id: int, db: Session = Depends(get_db)):
    hospital = await get_hospital(db, hospital_id)
    if not hospital:
        raise HTTPException(status_code=404, detail="Hospital not found")
    return hospital

@router.delete("/{hospital_id}", response_model=HospitalResponse)
async def delete_hospital_route(hospital_id: int, db: Session = Depends(get_db)):
    hospital = await delete_hospital(db, hospital_id)
    if not hospital:
        raise HTTPException(status_code=404, detail="Hospital not found")
    return hospital

@router.put("/{hospital_id}", response_model=HospitalResponse)
async def update_hospital_api(
    hospital_id: int,
    name: str = Form(...),
    logo: UploadFile = File(None),
    db: AsyncSession = Depends(get_db),
):
    logo_url = None
    if logo:
        file_obj = await logo.read()
        from io import BytesIO
        logo_url = upload_logo_to_s3(BytesIO(file_obj), logo.filename, folder="hospital_logos")
    update_data = {
        "name": name,
    }
    if logo_url:
        update_data["logo_url"] = logo_url
    updated_hospital = await update_hospital(db, hospital_id, HospitalUpdate(**update_data))
    presigned_logo_url = None
    if logo_url:
        from app.routers.test import get_presigned_url
        presigned_logo_url = get_presigned_url(file_url=logo_url)["presigned_url"]
    response = updated_hospital.model_dump()
    response["presigned_logo_url"] = presigned_logo_url
    return response

def generate_presigned_logo_url(logo_url: str):
    match = re.match(r"https://([^/.]+)\.s3\.([^/]+)\.amazonaws\.com/(.+)", logo_url)
    if not match:
        return logo_url
    bucket, region, key = match.groups()
    s3 = boto3.client(
        "s3",
        region_name=region,
        aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
        aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
    )
    return s3.generate_presigned_url(
        "get_object",
        Params={
            "Bucket": bucket,
            "Key": key,
            "ResponseContentDisposition": "inline"
        },
        ExpiresIn=300
    )

