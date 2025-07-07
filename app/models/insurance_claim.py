from sqlalchemy import Column, String, DECIMAL, TIMESTAMP, ForeignKey
from app.database import Base

class InsuranceClaim(Base):
    __tablename__ = "insurance_claims"
    claim_id = Column(String(20), primary_key=True)
    encounter_id = Column(String(20), ForeignKey("encounters.encounter_id"))
    insurance_id = Column(String(20), ForeignKey("insurance_providers.insurance_id"))
    claim_number = Column(String(50))
    preauth_number = Column(String(50))
    status = Column(String(30))
    submitted_at = Column(TIMESTAMP)
    approved_at = Column(TIMESTAMP)
    rejected_at = Column(TIMESTAMP)
    amount_claimed = Column(DECIMAL(10, 2))
    amount_approved = Column(DECIMAL(10, 2))
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)