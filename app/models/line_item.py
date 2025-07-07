from sqlalchemy import Column, String, Integer, DECIMAL, Text, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class LineItem(Base):
    __tablename__ = "line_items"
    line_item_id = Column(String(20), primary_key=True)
    encounter_id = Column(String(20), ForeignKey("encounters.encounter_id"))
    item_id = Column(String(20), ForeignKey("items.item_id"))
    qty = Column(Integer)
    unit_price = Column(DECIMAL(10, 2))
    total_price = Column(DECIMAL(10, 2))
    notes = Column(Text)
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)

    # Associations
    encounter = relationship("Encounter", back_populates="line_items")
    item = relationship("Item", back_populates="line_items")