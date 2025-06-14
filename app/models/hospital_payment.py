from sqlalchemy import Column, Integer, String, Date, Numeric, Boolean, ForeignKey, Text
from app.database import Base
from sqlalchemy.orm import relationship

class HospitalPayment(Base):
    __tablename__ = "hospital_payments"
    id = Column(Integer, primary_key=True, index=True)
    hospital_id = Column(Integer, ForeignKey("hospitals.id", ondelete="CASCADE"))
    date = Column(Date, nullable=False)
    amount = Column(Numeric(12, 2), nullable=False)
    payment_method = Column(String(50), nullable=False)
    reference = Column(String(100), nullable=True)
    status = Column(String(50), nullable=False)
    paid = Column(Boolean, default=False)
    remarks = Column(Text, nullable=True)

    hospital = relationship("Hospital", back_populates="hospital_payments")