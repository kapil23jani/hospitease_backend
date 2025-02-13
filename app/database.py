from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

DATABASE_URL="postgresql+asyncpg://hospitease_admin:postgres@localhost:5432/hospitease_backend"
# Use an async database engine
engine = create_async_engine(DATABASE_URL, echo=True)

Base = declarative_base()

# Create an async session factory
AsyncSessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False
)



# Dependency to get an async DB session
async def get_db():
    async with AsyncSessionLocal() as session:
        yield session
