from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Document(Base):
    __tablename__ = "documents"
    id = Column(Integer, primary_key=True, index=True)
    document_name = Column(String, nullable=False)
    document_type = Column(String, nullable=False)
    upload_date = Column(String, nullable=False)
    size = Column(String, nullable=False)
    status = Column(String, nullable=False)

    documentable_id = Column(Integer, nullable=False)
    documentable_type = Column(String, nullable=False)

    __mapper_args__ = {
        "polymorphic_on": documentable_type,
        "polymorphic_identity": "document",
        "with_polymorphic": "*"
    }
