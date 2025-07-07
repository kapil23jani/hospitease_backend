from sqlalchemy import Column, Integer, ForeignKey, Table
from app.database import Base

class HospitalPermission(Base):
    __tablename__ = "hospital_permissions"
    id = Column(Integer, primary_key=True, index=True)
    hospital_id = Column(Integer, ForeignKey("hospitals.id", ondelete="CASCADE"))
    permission_id = Column(Integer, ForeignKey("permissions.id", ondelete="CASCADE"))