from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.symtom import get_symptoms_by_appointment_id, create_symptom, get_symptom_by_id, update_symptom, delete_symptom
from app.schemas.symtom import SymptomCreate, SymptomResponse, SymptomUpdate
from sqlalchemy.future import select
from app.database import get_db
from app.models import Symptom
from app.crud.symtom import get_symptoms_by_appointment_id, get_all_symptoms_by_patient_id
from typing import List  
router = APIRouter()

# ✅ CREATE a symptom
@router.post("", response_model=SymptomResponse)
async def create_new_symptom(symptom: SymptomCreate, db: AsyncSession = Depends(get_db)):
    return await create_symptom(db, symptom)

@router.get("/", response_model=List[SymptomResponse])  # Use Pydantic model
async def get_symptoms(appointment_id: int, skip: int = 0, limit: int = 10, db: AsyncSession = Depends(get_db)):
    """Get symptoms for a specific appointment ID."""
    symptoms = await get_symptoms_by_appointment_id(db, appointment_id, skip, limit)
    return symptoms  # FastAPI will now use the Pydantic schema

@router.get("/{symptom_id}", response_model=SymptomResponse)
async def get_symptom(symptom_id: int, db: AsyncSession = Depends(get_db)):
    symptom = await get_symptom_by_id(db, symptom_id)  # 🛠️ Added `await`
    if not symptom:
        raise HTTPException(status_code=404, detail="Symptom not found")
    return symptom

@router.put("/{symptom_id}", response_model=SymptomResponse)
async def update_symptom_obj(symptom_id: int, symptom_data: SymptomUpdate, db: AsyncSession = Depends(get_db)):
    updated_symptom = await update_symptom(db, symptom_id, symptom_data)
    if not updated_symptom:
        raise HTTPException(status_code=404, detail="Symptom not found")
    return updated_symptom

@router.delete("/{symptom_id}", response_model=SymptomResponse)
async def delete_symptom_obj(symptom_id: int, db: AsyncSession = Depends(get_db)):
    deleted_symptom = await delete_symptom(db, symptom_id)  # 🛠️ Added `await`
    if not deleted_symptom:
        raise HTTPException(status_code=404, detail="Symptom not found")
    return deleted_symptom

@router.get("/patients/{patient_id}/symptoms", response_model=List[SymptomResponse])
async def get_symptoms_by_patient(
    patient_id: int,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db)
):
    return await get_all_symptoms_by_patient_id(db, patient_id, skip, limit)
