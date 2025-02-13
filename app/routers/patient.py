from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.patient import PatientCreate, PatientResponse
from app.crud.patient import create_patient

router = APIRouter()

@router.post("/", response_model=PatientResponse)
async def create_patient_api(patient: PatientCreate, db: AsyncSession = Depends(get_db)):
    return await create_patient(db, patient)
