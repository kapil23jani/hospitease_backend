from sqlalchemy import Column, String, Text, TIMESTAMP, Boolean, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.database import Base
import uuid

class ChatMessage(Base):
    __tablename__ = "chat_messages"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    sender_id = Column(String, nullable=False)
    receiver_id = Column(String, nullable=False)
    message = Column(Text, nullable=True)
    sent_at = Column(TIMESTAMP, nullable=False)
    seen_by_sender = Column(Boolean, default=True)
    seen_by_receiver = Column(Boolean, default=False)
    doc_url = Column(Text, nullable=True)  # For document attachment (optional)