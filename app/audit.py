import json
from datetime import datetime
from sqlalchemy import Column, Integer, String, DateTime, Text, event
from sqlalchemy.orm import declarative_base, Session
import contextvars

Base = declarative_base()

# ContextVar for current user tracking
current_user_id = contextvars.ContextVar("current_user_id", default=None)

class AuditLog(Base):
    __tablename__ = "audit_logs"

    id = Column(Integer, primary_key=True, index=True)
    table_name = Column(String, nullable=False)
    record_id = Column(Integer, nullable=False)
    action = Column(String, nullable=False)  # 'create' or 'update'
    timestamp = Column(DateTime, default=datetime.utcnow, nullable=False)
    user_id = Column(Integer, nullable=True)  # track user if available
    old_data = Column(Text, nullable=True)
    new_data = Column(Text, nullable=True)

def model_to_dict(obj):
    """Serialize SQLAlchemy model instance to dict."""
    return {c.key: getattr(obj, c.key) for c in obj.__table__.columns}

from sqlalchemy import inspect

@event.listens_for(Session, "after_flush")
def audit_after_flush(session, flush_context):
    for obj in session.new:
        if hasattr(obj, '__tablename__') and obj.__tablename__ not in ['audit_logs', 'chat_messages']:
            audit = AuditLog(
                table_name=obj.__tablename__,
                record_id=getattr(obj, 'id', None),
                action='create',
                old_data=None,
                new_data=json.dumps(model_to_dict(obj), default=str),
                timestamp=datetime.utcnow(),
                user_id=current_user_id.get(),
            )
            session.add(audit)

    for obj in session.dirty:
        if session.is_modified(obj, include_collections=False):
            if hasattr(obj, '__tablename__') and obj.__tablename__ not in ['audit_logs', 'chat_messages']:
                old_data_dict = {}

                # Use inspect to access attribute history safely
                state = inspect(obj)
                for attr in obj.__mapper__.column_attrs:
                    hist = state.attrs[attr.key].history
                    if hist.has_changes():
                        if hist.deleted:
                            old_data_dict[attr.key] = hist.deleted[0]
                        else:
                            old_data_dict[attr.key] = None
                    else:
                        old_data_dict[attr.key] = getattr(obj, attr.key)

                audit = AuditLog(
                    table_name=obj.__tablename__,
                    record_id=getattr(obj, 'id', None),
                    action='update',
                    old_data=json.dumps(old_data_dict, default=str),
                    new_data=json.dumps(model_to_dict(obj), default=str),
                    timestamp=datetime.utcnow(),
                    user_id=current_user_id.get(),
                )
                session.add(audit)
