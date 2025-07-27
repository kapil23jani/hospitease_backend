from sqlalchemy import Column, Integer, String, Text, DECIMAL, ForeignKey, JSON
from sqlalchemy.orm import relationship
from app.database import Base

class Test(Base):
  __tablename__ = "tests"

  id = Column(Integer, primary_key=True, index=True)
  appointment_id = Column(Integer, ForeignKey("appointments.id"), nullable=False)
  test_details = Column(Text, nullable=False)
  status = Column(String(50), nullable=False)
  cost = Column(DECIMAL(10, 2), nullable=True)
  description = Column(Text, nullable=True)
  doctor_notes = Column(Text, nullable=True)
  staff_notes = Column(Text, nullable=True)
  test_date = Column(String, nullable=False)
  test_done_date = Column(String, nullable=True)
  _tests_docs_urls = Column("tests_docs_urls", JSON, nullable=True)
  patient = relationship("Appointment", back_populates="tests")

  @property
  def tests_docs_urls(self):
    import json
    if isinstance(self._tests_docs_urls, str):
        return json.loads(self._tests_docs_urls)
    return self._tests_docs_urls

  @tests_docs_urls.setter
  def tests_docs_urls(self, value):
    self._tests_docs_urls = value

# In your endpoint or CRUD function, before returning:
# if isinstance(test.tests_docs_urls, str):
#     import json
#     test.tests_docs_urls = json.loads(test.tests_docs_urls)
# return test
