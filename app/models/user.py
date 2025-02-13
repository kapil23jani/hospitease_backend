from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String, index=True)
    last_name = Column(String, index=True)
    gender = Column(String)
    email = Column(String, index=True)
    phone_number = Column(String, nullable=True)
    password = Column(String)
    role_id = Column(Integer, ForeignKey('roles.id'))
    role = relationship('Role', back_populates='users')
