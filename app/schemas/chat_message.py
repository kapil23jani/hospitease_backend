from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from uuid import UUID

class ChatMessageResponse(BaseModel):
    id: UUID
    sender_id: str
    receiver_id: str
    message: Optional[str]
    sent_at: datetime
    seen_by_sender: bool
    seen_by_receiver: bool
    doc_urls: Optional[List[str]] = None  # <-- Use a list for file URLs

    class Config:
        from_attributes = True