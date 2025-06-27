from fastapi import APIRouter, HTTPException, Body
from pydantic import BaseModel
import openai
import os

router = APIRouter()

# You can use env variable or hardcode for testing (not recommended for prod)
client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY") or "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")

class SupportChatRequest(BaseModel):
    prompt: str

@router.post("/api/support-chat")
async def support_chat(request: SupportChatRequest):
    try:
        chat = client.chat.completions.create(
            model="gpt-4",
            messages=[{"role": "user", "content": request.prompt}],
            temperature=0.3
        )
        response = chat.choices[0].message.content
        return {"response": response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))