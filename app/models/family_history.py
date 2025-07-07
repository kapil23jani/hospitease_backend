from sqlalchemy import Column, Integer, String, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.database import Base

class FamilyHistory(Base):
    __tablename__ = "family_history"

    id = Column(Integer, primary_key=True, index=True)
    appointment_id = Column(Integer, ForeignKey('appointments.id'))  # Ensure this exists!
    # appointment_id = Column(Integer, ForeignKey("appointment.id", ondelete="CASCADE"), nullable=False)
    relationship_to_you = Column(String(100), nullable=False)
    additional_notes = Column(Text, nullable=True)

    # Relationship (MANY FamilyHistories → ONE Appointment)
    appointment = relationship("Appointment", back_populates="family_histories")
