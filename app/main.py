from fastapi import FastAPI
from app.database import AsyncSessionLocal, engine
from app.models import Base
from app.routers import role
from app.routers import user
from app.routers import hospital
from app.routers import patient
from app.routers import doctor
from app.routers import appointment


async def create_tables():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

app = FastAPI()

@app.on_event("startup")
async def on_startup():
    await create_tables()

app.include_router(role.router, prefix="/roles", tags=["Roles"])
app.include_router(user.router, prefix="/users", tags=["Users"])
app.include_router(hospital.router, prefix="/hospitals", tags=["Hospitals"])
app.include_router(patient.router, prefix="/patients", tags=["Patients"])
app.include_router(doctor.router, prefix="/doctors", tags=["Doctors"])
app.include_router(appointment.router)





