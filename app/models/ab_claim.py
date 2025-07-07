from sqlalchemy import Column, String, Text, TIMESTAMP, ForeignKey
from app.database import Base

class ABClaim(Base):
    __tablename__ = "ab_claims"
    ab_claim_id = Column(String(20), primary_key=True)
    claim_id = Column(String(20), ForeignKey("insurance_claims.claim_id"))
    urn = Column(String(30))
    utn = Column(String(30))
    bis_status = Column(String(30))
    tms_status = Column(String(30))
    ehr_json = Column(Text)
    created_at = Column(TIMESTAMP)
    updated_at = Column(TIMESTAMP)