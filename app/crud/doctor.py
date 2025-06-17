from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from passlib.context import CryptContext
from app.models.user import User
from app.models.role import Role
from app.models.doctor import Doctor
from app.models.hospital import Hospital
from app.schemas.doctor import DoctorCreate, DoctorUpdate
from sqlalchemy.orm import selectinload

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def create_doctor(db: AsyncSession, doctor: DoctorCreate):
    try:
        hashed_password = pwd_context.hash(doctor.password)

        role_result = await db.execute(select(Role).filter(Role.name == "Doctor"))
        doctor_role = role_result.scalars().first()
        if not doctor_role:
            raise HTTPException(status_code=400, detail="Doctor role not found")

        user_result = await db.execute(select(User).filter(User.email == doctor.email))
        user = user_result.scalars().first()

        if not user:
            new_user = User(
                first_name=doctor.first_name,
                last_name=doctor.last_name,
                email=doctor.email,
                password=doctor.password,
                role_id=doctor_role.id
            )
            db.add(new_user)
            await db.commit()
            await db.refresh(new_user)
        else:
            new_user = user
        
        new_doctor = Doctor(
            title=doctor.title,
            first_name=doctor.first_name,
            last_name=doctor.last_name,
            gender=doctor.gender,
            date_of_birth=doctor.date_of_birth,
            blood_group=doctor.blood_group,
            mobile_number=doctor.mobile_number,
            emergency_contact=doctor.emergency_contact,
            specialization=doctor.specialization,
            experience=doctor.experience,
            medical_licence_number=doctor.medical_licence_number,
            licence_authority=doctor.licence_authority,
            license_expiry_date=doctor.license_expiry_date,
            address=doctor.address,
            city=doctor.city,
            state=doctor.state,
            country=doctor.country,
            zipcode=doctor.zipcode,
            phone_number=doctor.phone_number,
            email=doctor.email,
            user_id=new_user.id,
            hospital_id=doctor.hospital_id
        )

        db.add(new_doctor)
        await db.commit()
        # Eagerly load hospital after creation
        await db.refresh(new_doctor)
        result = await db.execute(
            select(Doctor)
            .where(Doctor.id == new_doctor.id)
            .options(selectinload(Doctor.hospital))
        )
        new_doctor = result.scalar_one_or_none()
        return new_doctor

    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=f"Integrity Error: {str(e)}")

async def get_doctors(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(Doctor)
        .offset(skip)
        .limit(limit)
        .options(selectinload(Doctor.hospital))  # Eager load hospital
    )
    doctors = result.scalars().all()
    return doctors

async def get_doctor_by_id(db: AsyncSession, doctor_id: int):
    result = await db.execute(
        select(Doctor)
        .where(Doctor.id == doctor_id)
        .options(selectinload(Doctor.hospital))  # Eager load hospital
    )
    doctor = result.scalar_one_or_none()
    return doctor

async def update_doctor(db: AsyncSession, doctor_id: int, doctor: DoctorUpdate):
    result = await db.execute(
        select(Doctor)
        .where(Doctor.id == doctor_id)
        .options(selectinload(Doctor.hospital))  # Eager load hospital
    )
    db_doctor = result.scalar_one_or_none()

    if not db_doctor:
        return None

    for key, value in doctor.dict(exclude_unset=True).items():
        setattr(db_doctor, key, value)

    await db.commit()
    await db.refresh(db_doctor)
    return db_doctor

async def delete_doctor(db: AsyncSession, doctor_id: int):
    result = await db.execute(
        select(Doctor)
        .where(Doctor.id == doctor_id)
        .options(selectinload(Doctor.hospital))  # Eager load hospital
    )
    db_doctor = result.scalar_one_or_none()

    if db_doctor:
        await db.delete(db_doctor)
        await db.commit()
        return True
    return False

async def get_doctors_by_hospital(db: AsyncSession, hospital_id: int):
    result = await db.execute(
        select(Doctor)
        .where(Doctor.hospital_id == hospital_id)
        .options(selectinload(Doctor.hospital))  # Eager load hospital
    )
    doctors = result.scalars().all()
    return doctors