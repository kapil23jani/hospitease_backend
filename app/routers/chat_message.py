from fastapi import APIRouter, Depends, HTTPException, WebSocket, WebSocketDisconnect, Body, UploadFile, File, Form
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Dict
from app.database import get_db
from app.schemas.chat_message import ChatMessageResponse
from app.crud.chat_message import get_pending_messages, mark_messages_seen, save_message, get_chat_history
import os
from uuid import uuid4
from sqlalchemy.future import select
from app.models.chat_message import ChatMessage
from sqlalchemy import func, desc

router = APIRouter(prefix="/chat", tags=["Chat"])

# Track connected users
active_connections: Dict[str, WebSocket] = {}

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.get("/pending/{user_id}/{peer_id}", response_model=List[ChatMessageResponse])
async def fetch_pending_messages(user_id: str, peer_id: str, db: AsyncSession = Depends(get_db)):
    return await get_pending_messages(db, user_id, peer_id)

@router.post("/seen/{user_id}/{peer_id}")
async def mark_seen(user_id: str, peer_id: str, db: AsyncSession = Depends(get_db)):
    """
    Mark all messages from peer_id to user_id as seen.
    """
    result = await db.execute(
        select(ChatMessage).where(
            (ChatMessage.sender_id == peer_id) &
            (ChatMessage.receiver_id == user_id) &
            (ChatMessage.seen_by_receiver == False)
        )
    )
    messages = result.scalars().all()
    count = 0
    for msg in messages:
        msg.seen_by_receiver = True
        count += 1
    await db.flush()
    await db.commit()
    return {"marked_seen": count}

@router.websocket("/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str, db: AsyncSession = Depends(get_db)):
    await websocket.accept()
    active_connections[user_id] = websocket
    try:
        while True:
            data = await websocket.receive_json()
            to_user = str(data.get("to"))
            message = data.get("message")
            doc_url = data.get("doc_url")  # Optional
            # Save to DB
            await save_message(db, str(user_id), to_user, message, doc_url)
            payload = {
                "from": user_id,
                "to": to_user,
                "message": message,
                "doc_url": doc_url
            }
            print(f"WebSocket sending payload: {payload}")
            # Send to receiver if online
            if to_user in active_connections:
                await active_connections[to_user].send_json(payload)
            # Also send to sender (so sender gets their own message event)
            if user_id in active_connections:
                await active_connections[user_id].send_json(payload)
    except WebSocketDisconnect:
        active_connections.pop(user_id, None)

@router.post("/send")
async def send_chat_message(
    sender_id: str = Form(...),
    receiver_id: str = Form(...),
    message: str = Form(None),
    files: list[UploadFile] = File(None),
    db: AsyncSession = Depends(get_db)
):
    print(f"Received /chat/send from {sender_id} to {receiver_id} with message: {message}")
    doc_urls = []
    if files:
        for file in files:
            ext = os.path.splitext(file.filename)[1]
            file_id = f"{uuid4()}{ext}"
            file_path = os.path.join(UPLOAD_DIR, file_id)
            with open(file_path, "wb") as f:
                content = await file.read()
                f.write(content)
            doc_urls.append(f"/uploads/{file_id}")

    # Save message and doc_urls (as JSON string or comma-separated, depending on your DB schema)
    doc_url_str = ",".join(doc_urls) if doc_urls else None
    chat_msg = await save_message(db, sender_id, receiver_id, message, doc_url_str)
    if chat_msg is None:
        return {"status": "duplicate_or_empty", "message_id": None, "doc_urls": doc_urls}
    return {"status": "sent", "message_id": str(chat_msg.id), "doc_urls": doc_urls}

def orm_to_response(msg):
    # Split doc_url string into a list, or return None if empty
    doc_urls = msg.doc_url.split(",") if msg.doc_url else None
    return ChatMessageResponse(
        id=msg.id,
        sender_id=msg.sender_id,
        receiver_id=msg.receiver_id,
        message=msg.message,
        sent_at=msg.sent_at,
        seen_by_sender=msg.seen_by_sender,
        seen_by_receiver=msg.seen_by_receiver,
        doc_urls=doc_urls
    )

@router.get("/history/{user_id}/{peer_id}", response_model=List[ChatMessageResponse])
async def fetch_chat_history(user_id: str, peer_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(ChatMessage).where(
            ((ChatMessage.sender_id == user_id) & (ChatMessage.receiver_id == peer_id)) |
            ((ChatMessage.sender_id == peer_id) & (ChatMessage.receiver_id == user_id))
        ).order_by(ChatMessage.sent_at.asc())
    )
    messages = result.scalars().all()
    return [orm_to_response(msg) for msg in messages]

@router.get("/unread_counts/{user_id}")
async def get_unread_counts(user_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(ChatMessage.sender_id, func.count())
        .where(ChatMessage.receiver_id == user_id)
        .where(ChatMessage.seen_by_receiver == False)
        .group_by(ChatMessage.sender_id)
    )
    rows = result.all()
    print("Unread counts raw rows:", rows)
    unread_counts = {row[0]: row[1] for row in rows}
    return unread_counts

@router.get("/unread_count/{user_id}")
async def get_unread_counts_alias(user_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(ChatMessage)
        .where(ChatMessage.receiver_id == user_id)
        .where(ChatMessage.seen_by_receiver == False)
    )
    messages = result.scalars().all()
    print(messages)
    return await get_unread_counts(user_id, db)

@router.get("/doctor_unread_counts/{doctor_id}")
async def doctor_unread_counts(doctor_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(ChatMessage.sender_id, func.count())
        .where(ChatMessage.receiver_id == doctor_id)
        .where(ChatMessage.seen_by_receiver == False)
        .group_by(ChatMessage.sender_id)
    )
    rows = result.all()
    # Returns: { "patientId1": count, "patientId2": count, ... }
    return {str(row[0]): row[1] for row in rows}

@router.get("/doctor/{doctor_id}")
async def get_doctor_chats(doctor_id: str, db: AsyncSession = Depends(get_db)):
    # Get all unique patient IDs who have chatted with this doctor
    result = await db.execute(
        select(ChatMessage.sender_id)
        .where(ChatMessage.receiver_id == doctor_id)
        .group_by(ChatMessage.sender_id)
    )
    patient_ids = [row[0] for row in result.all()]

    chats = []
    for patient_id in patient_ids:
        # Get latest message between doctor and patient
        latest_msg_result = await db.execute(
            select(ChatMessage)
            .where(
                ((ChatMessage.sender_id == patient_id) & (ChatMessage.receiver_id == doctor_id)) |
                ((ChatMessage.sender_id == doctor_id) & (ChatMessage.receiver_id == patient_id))
            )
            .order_by(desc(ChatMessage.sent_at))
            .limit(1)
        )
        latest_msg = latest_msg_result.scalar_one_or_none()

        # Get unread count from this patient to doctor
        unread_result = await db.execute(
            select(func.count())
            .where(
                (ChatMessage.sender_id == patient_id) &
                (ChatMessage.receiver_id == doctor_id) &
                (ChatMessage.seen_by_receiver == False)
            )
        )
        unread_count = unread_result.scalar() or 0

        chats.append({
            "patient_id": patient_id,
            "latest_message": ChatMessageResponse.model_validate(latest_msg) if latest_msg else None,
            "unread_count": unread_count
        })

    return chats