from sqlalchemy import Column, String, Text, DECIMAL, Boolean, TIMESTAMP
from app.database import Base
from sqlalchemy.orm import relationship
from app.models.line_item import LineItem

class Item(Base):
    __tablename__ = "items"
    item_id = Column(String(20), primary_key=True)
    name = Column(String(100), nullable=False)
    category = Column(String(50), nullable=True)
    description = Column(Text, nullable=True)
    price = Column(DECIMAL(10, 2), nullable=True)
    is_taxable = Column(Boolean, default=False)
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)
    line_items = relationship("LineItem", back_populates="item")