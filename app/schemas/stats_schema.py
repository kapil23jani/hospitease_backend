from pydantic import BaseModel

class StatsResponse(BaseModel):
    appointments: int
    patients: int
    doctors: int
    revenue: float
    pendingBills: int
    completedAppointments: int
    cancelledAppointments: int
    malePatients: int
    femalePatients: int
    otherPatients: int
