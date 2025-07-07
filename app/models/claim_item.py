from sqlalchemy import Column, String, DECIMAL, TIMESTAMP, ForeignKey
from app.database import Base

class ClaimItem(Base):
    __tablename__ = "claim_items"
    claim_item_id = Column(String(20), primary_key=True)
    claim_id = Column(String(20), ForeignKey("insurance_claims.claim_id"))
    line_item_id = Column(String(20), ForeignKey("line_items.line_item_id"))
    claimed_amount = Column(DECIMAL(10, 2))
    approved_amount = Column(DECIMAL(10, 2))
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)