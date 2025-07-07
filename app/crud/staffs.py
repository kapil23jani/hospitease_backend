from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from passlib.context import CryptContext
from sqlalchemy.orm import selectinload
from app.models.user import User
from app.models.role import Role
from app.models.staff import Staff
from app.models.hospital import Hospital
from app.schemas.staff import StaffCreate, StaffUpdate

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def create_staff(db: AsyncSession, staff: StaffCreate):
    try:

        # Get Staff role
        role_result = await db.execute(select(Role).filter(Role.name == "Staff"))
        staff_role = role_result.scalars().first()
        if not staff_role:
            raise HTTPException(status_code=400, detail="Staff role not found")

        # Check if user exists
        user_result = await db.execute(select(User).filter(User.email == staff.email))
        user = user_result.scalars().first()

        if not user:
            new_user = User(
                first_name=staff.first_name,
                last_name=staff.last_name,
                email=staff.email,
                password=staff.password,
                role_id=staff_role.id
            )
            db.add(new_user)
            await db.commit()
            await db.refresh(new_user)
        else:
            new_user = user

        new_staff = Staff(
            hospital_id=staff.hospital_id,
            user_id=new_user.id,
            first_name=staff.first_name,
            last_name=staff.last_name,
            title=staff.title,
            gender=staff.gender,
            date_of_birth=staff.date_of_birth,
            phone_number=staff.phone_number,
            email=staff.email,
            role=staff.role,
            department=staff.department,
            specialization=staff.specialization,
            qualification=staff.qualification,
            experience=staff.experience,
            joining_date=staff.joining_date,
            is_active=staff.is_active,
            address=staff.address,
            city=staff.city,
            state=staff.state,
            country=staff.country,
            zipcode=staff.zipcode,
            emergency_contact=staff.emergency_contact,
            photo_url=staff.photo_url,
        )

        db.add(new_staff)
        await db.commit()
        await db.refresh(new_staff)

        # Eagerly load hospital and user
        result = await db.execute(
            select(Staff)
            .where(Staff.id == new_staff.id)
            .options(selectinload(Staff.hospital), selectinload(Staff.user))
        )
        new_staff = result.scalar_one_or_none()
        return new_staff

    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=f"Integrity Error: {str(e)}")

async def get_staff(db: AsyncSession, staff_id: int):
    result = await db.execute(
        select(Staff)
        .where(Staff.id == staff_id)
        .options(selectinload(Staff.hospital), selectinload(Staff.user))
    )
    return result.scalar_one_or_none()

async def get_all_staff(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(Staff)
        .offset(skip)
        .limit(limit)
        .options(selectinload(Staff.hospital), selectinload(Staff.user))
    )
    return result.scalars().all()

async def update_staff(db: AsyncSession, staff_id: int, staff: StaffUpdate):
    result = await db.execute(
        select(Staff)
        .where(Staff.id == staff_id)
        .options(selectinload(Staff.hospital), selectinload(Staff.user))
    )
    db_staff = result.scalar_one_or_none()

    if not db_staff:
        return None

    for key, value in staff.dict(exclude_unset=True).items():
        setattr(db_staff, key, value)

    await db.commit()
    await db.refresh(db_staff)
    return db_staff

async def delete_staff(db: AsyncSession, staff_id: int):
    result = await db.execute(
        select(Staff)
        .where(Staff.id == staff_id)
        .options(selectinload(Staff.hospital), selectinload(Staff.user))
    )
    db_staff = result.scalar_one_or_none()

    if db_staff:
        await db.delete(db_staff)
        await db.commit()
        return True
    return False

async def get_staff_by_hospital(db: AsyncSession, hospital_id: int, skip: int = 0, limit: int = 100):
    result = await db.execute(
        select(Staff)
        .where(Staff.hospital_id == hospital_id)
        .offset(skip)
        .limit(limit)
        .options(selectinload(Staff.hospital), selectinload(Staff.user))
    )
    return result.scalars().all()