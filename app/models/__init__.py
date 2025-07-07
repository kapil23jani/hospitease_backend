from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

from app.models.role import Role
from app.models.hospital import Hospital
from app.models.patient import Patient
from .appointment import Appointment
from .patient import Patient
from .doctor import Doctor
from .symtom import Symptom
from .vital import Vital
from .user import User

from .staff import Staff
from .staff_responsibility import StaffResponsibility, StaffResponsibilityAssignment