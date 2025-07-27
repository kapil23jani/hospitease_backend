from app.models.document import Document
from sqlalchemy import Column, String

class AppointmentDocument(Document):
    __tablename__ = None
    __mapper_args__ = {
        "polymorphic_identity": "appointment",
    }
    file_url = Column(String, nullable=True)
