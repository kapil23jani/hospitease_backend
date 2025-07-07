from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas import medical_history as schemas
from app.crud import medical_history as crud

router = APIRouter()

@router.post("/", response_model=schemas.MedicalHistory)
async def create(mh: schemas.MedicalHistoryCreate, db: AsyncSession = Depends(get_db)):
    return await crud.create_medical_history(db, mh)

@router.get("/patient/{patient_id}", response_model=list[schemas.MedicalHistory])
async def list_for_patient(patient_id: int, db: AsyncSession = Depends(get_db)):
    return await crud.get_medical_histories_by_patient(db, patient_id)

@router.get("/{mh_id}", response_model=schemas.MedicalHistory)
async def read(mh_id: int, db: AsyncSession = Depends(get_db)):
    mh = await crud.get_medical_history(db, mh_id)
    if not mh:
        raise HTTPException(status_code=404, detail="Medical history not found")
    return mh

@router.put("/{mh_id}", response_model=schemas.MedicalHistory)
async def update(mh_id: int, update_data: schemas.MedicalHistoryUpdate, db: AsyncSession = Depends(get_db)):
    updated = await crud.update_medical_history(db, mh_id, update_data)
    if not updated:
        raise HTTPException(status_code=404, detail="Medical history not found")
    return updated

@router.delete("/{mh_id}")
async def delete(mh_id: int, db: AsyncSession = Depends(get_db)):
    deleted = await crud.delete_medical_history(db, mh_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Medical history not found")
    return {"message": "Medical history deleted successfully"}
