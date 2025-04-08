from app.models.document import Document

class AppointmentDocument(Document):
    __tablename__ = None  # No separate table, uses the parent 'documents' table
    __mapper_args__ = {
        "polymorphic_identity": "appointment",
    }
