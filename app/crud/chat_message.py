from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.chat_message import ChatMessage
from app.schemas.chat_message import ChatMessageResponse
from datetime import datetime, timedelta

async def save_message(db: AsyncSession, sender_id: str, receiver_id: str, message: str, doc_url: str = None):
    if not message or not message.strip():
        return None  # Don't save empty messages
    # Check for duplicate in the last few seconds
    recent_time = datetime.utcnow() - timedelta(seconds=5)
    result = await db.execute(
        select(ChatMessage).where(
            ChatMessage.sender_id == sender_id,
            ChatMessage.receiver_id == receiver_id,
            ChatMessage.message == message,
            ChatMessage.sent_at > recent_time
        )
    )
    if result.scalar():
        return None  # Duplicate, don't save again

    chat_msg = ChatMessage(
        sender_id=sender_id,
        receiver_id=receiver_id,
        message=message,
        sent_at=datetime.utcnow(),
        seen_by_sender=True,
        seen_by_receiver=False,
        doc_url=doc_url
    )
    db.add(chat_msg)
    await db.commit()
    await db.refresh(chat_msg)
    return chat_msg

def parse_doc_urls(doc_url_str):
    if not doc_url_str:
        return []
    return [url.strip() for url in doc_url_str.split(",") if url.strip()]

async def get_pending_messages(db: AsyncSession, user_id: str, peer_id: str):
    result = await db.execute(
        select(ChatMessage)
        .where(ChatMessage.receiver_id == user_id, ChatMessage.sender_id == peer_id, ChatMessage.seen_by_receiver == False)
        .order_by(ChatMessage.sent_at)
    )
    messages = result.scalars().all()
    # Convert doc_url_str to doc_urls list for each message
    response = []
    for msg in messages:
        doc_urls = parse_doc_urls(getattr(msg, "doc_url", None))
        response.append({
            "id": msg.id,
            "sender_id": msg.sender_id,
            "receiver_id": msg.receiver_id,
            "message": msg.message,
            "sent_at": msg.sent_at,
            "seen_by_sender": msg.seen_by_sender,
            "seen_by_receiver": msg.seen_by_receiver,
            "doc_urls": doc_urls
        })
    return response

async def mark_messages_seen(db: AsyncSession, user_id: str, peer_id: str):
    result = await db.execute(
        select(ChatMessage)
        .where(ChatMessage.receiver_id == user_id, ChatMessage.sender_id == peer_id, ChatMessage.seen_by_receiver == False)
    )
    messages = result.scalars().all()
    for msg in messages:
        msg.seen_by_receiver = True
    await db.commit()
    return len(messages)

async def get_chat_history(db: AsyncSession, user_id: str, peer_id: str):
    result = await db.execute(
        select(ChatMessage)
        .where(
            ((ChatMessage.sender_id == user_id) & (ChatMessage.receiver_id == peer_id)) |
            ((ChatMessage.sender_id == peer_id) & (ChatMessage.receiver_id == user_id))
        )
        .order_by(ChatMessage.sent_at)
    )
    messages = result.scalars().all()
    return [ChatMessageResponse.model_validate(msg) for msg in messages]