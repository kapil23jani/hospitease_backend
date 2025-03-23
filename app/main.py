from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import AsyncSessionLocal, engine
from app.models import Base
from app.routers import role, user, hospital, patient, doctor, appointment, symtom, vital, test, appointment_medicine

app = FastAPI(title="Hospitease API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

async def create_tables():
    try:
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.create_all)
        print("✅ Database tables created successfully.")
    except Exception as e:
        print(f"❌ Error creating tables: {str(e)}")

@app.on_event("startup")
async def on_startup():
    await create_tables()

app.include_router(role.router, prefix="/roles", tags=["Roles"])
app.include_router(user.router, prefix="/users", tags=["Users"])
app.include_router(hospital.router, prefix="/hospitals", tags=["Hospitals"])
app.include_router(patient.router, prefix="/patients", tags=["Patients"])
app.include_router(doctor.router, prefix="/doctors", tags=["Doctors"])
app.include_router(appointment.router, prefix="/appointments", tags=["Appointments"])
app.include_router(symtom.router, prefix="/symptoms", tags=["Symtoms"])
app.include_router(vital.router, prefix="/vitals", tags=["Vitals"])
app.include_router(test.router, prefix="/tests", tags=["Tests"])
app.include_router(appointment_medicine.router, prefix="/appointment_medicines", tags=["Appointment Medicines"])



@app.get("/", tags=["Health"])
async def health_check():
    return {"message": "Hospitease API is running 🚀"}

