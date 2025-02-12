from fastapi import FastAPI
from .database import engine, Base
from .routers import user, auth

app = FastAPI()

@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

app.include_router(user.router, prefix="/api", tags=["Users"])
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
