from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

from app.models.role import Role
# from app.models.role import User