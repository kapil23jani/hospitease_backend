from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import AsyncSessionLocal, engine
from app.models import Base
from app.routers import role, user, hospital, patient, doctor, appointment, symtom, vital, test, appointment_medicine, appointment_document, health_info, family_history, medical_history, receipt
from app.routers import stats_routes, permission, hospital_permissions, hospital_payment  # <-- add hospital_payment import
from app.routers import admin_dashboard  # <-- Add this import
from app.routers import staff  # <-- Add this import
from app.routers import bed_type
from app.routers import ward
from app.routers.support_chat import router as support_chat_router
from app.routers.smart_report import router as smart_report_router  # <-- Add this import
from app.routers import bed
from app.routers import admission
from app.routers import admission_vital  # <-- add this import
from app.routers import admission_medicine
from app.routers import nursing_note  # <-- add this import
from app.routers import admission_test  # <-- add this import
from app.routers import admission_diet
from app.routers import admission_discharge

app = FastAPI()

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
app.include_router(appointment_document.router, prefix="/appointment_documents", tags=["Appointment Documents"])
app.include_router(health_info.router, prefix="/health_informations", tags=["Health Informations"])
app.include_router(family_history.router, prefix="/family_histories", tags=["Family Histories"])
app.include_router(medical_history.router, prefix="/medical_histories", tags=["Medical Histories"])
app.include_router(receipt.router, prefix="/receipts", tags=["Receipts"])
app.include_router(stats_routes.router, prefix="/api", tags=["Statistics"])
app.include_router(permission.router, prefix="/permissions", tags=["Permissions"])  # <-- add this line
app.include_router(hospital_permissions.router, prefix="/hospital-permissions", tags=["Hospital Permissions"])
app.include_router(hospital_payment.router, prefix="/hospital-payments", tags=["Hospital Payments"])  # <-- add this line
app.include_router(bed_type.router)
app.include_router(bed.router)
app.include_router(admin_dashboard.router)  
app.include_router(support_chat_router)
app.include_router(smart_report_router)
app.include_router(staff.router)
app.include_router(ward.router)
app.include_router(admission.router)
app.include_router(admission_vital.router)  # <-- add this line
app.include_router(admission_medicine.router)  # <-- add this line
app.include_router(nursing_note.router)  # <-- add this line
app.include_router(admission_test.router)  # <-- add this line
app.include_router(admission_diet.router)  # <-- add this line
app.include_router(admission_discharge.router)  # <-- add this line

@app.get("/", tags=["Health"])
async def health_check():
    return {"message": "Hospitease API is running 🚀"}