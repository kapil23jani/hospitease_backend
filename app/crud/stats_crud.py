from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.patient import Patient
from app.models.doctor import Doctor
from app.models.appointment import Appointment
from app.models.receipt import Receipt
async def get_stats(db: AsyncSession):
    result = {}

    # Appointments count
    appointments = await db.execute(select(func.count()).select_from(Appointment))
    result["appointments"] = appointments.scalar_one()

    # Patients count
    patients = await db.execute(select(func.count()).select_from(Patient))
    result["patients"] = patients.scalar_one()

    # Doctors count
    doctors = await db.execute(select(func.count()).select_from(Doctor))
    result["doctors"] = doctors.scalar_one()

    # Revenue (sum of receipt amounts)
    revenue = await db.execute(select(func.coalesce(func.sum(Receipt.total), 0)))
    result["revenue"] = revenue.scalar_one()

    # Pending bills
    pending_bills = await db.execute(select(func.count()).select_from(Receipt).where(Receipt.is_paid != True))
    result["pendingBills"] = pending_bills.scalar_one()

    # Completed appointments
    completed = await db.execute(select(func.count()).select_from(Appointment).where(Appointment.status == "completed"))
    result["completedAppointments"] = completed.scalar_one()

    # Cancelled appointments
    cancelled = await db.execute(select(func.count()).select_from(Appointment).where(Appointment.status == "cancelled"))
    result["cancelledAppointments"] = cancelled.scalar_one()

    # Male patients
    male = await db.execute(select(func.count()).select_from(Patient).where(Patient.gender == "male"))
    result["malePatients"] = male.scalar_one()

    # Female patients
    female = await db.execute(select(func.count()).select_from(Patient).where(Patient.gender == "female"))
    result["femalePatients"] = female.scalar_one()

    # Other gender
    other = await db.execute(select(func.count()).select_from(Patient).where(Patient.gender.notin_(["male", "female"])))
    result["otherPatients"] = other.scalar_one()

    return result
