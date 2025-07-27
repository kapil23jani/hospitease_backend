from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from app.crud.appointment import ai_prescription_suggestion

router = APIRouter()

@router.post("/api/ai/prescription")
async def get_ai_prescription(
    symptoms_text: str = Form(None),
    symptoms_audio: UploadFile = File(None),
    language: str = Form("en")
):
    if not symptoms_text and not symptoms_audio:
        raise HTTPException(status_code=400, detail="Provide symptoms as text or audio.")
    return await ai_prescription_suggestion(symptoms_text, symptoms_audio, language)