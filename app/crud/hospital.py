from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException

from app.models.hospital import Hospital
from app.models.user import User
from app.schemas.hospital import HospitalCreate, HospitalUpdate
from app.schemas.hospital import HospitalResponse  
from app.schemas.permission import PermissionResponse
from app.schemas.hospital_payment import HospitalPaymentResponse
from app.utils.s3 import get_presigned_url

async def create_hospital(db: AsyncSession, hospital: HospitalCreate):
    try:
        if hospital.admin_id:
            admin = await db.execute(select(User).filter(User.id == hospital.admin_id))
            admin_user = admin.scalars().first()
            if not admin_user:
                raise HTTPException(status_code=404, detail="Admin user not found")

        new_hospital = Hospital(
            name=hospital.name,
            registration_number=hospital.registration_number,
            type=hospital.type,
            logo_url=hospital.logo_url,
            website=hospital.website,
            admin_id=hospital.admin_id,
            owner_name=hospital.owner_name,
            admin_contact_number=hospital.admin_contact_number,
            number_of_beds=hospital.number_of_beds,
            departments=hospital.departments,
            specialties=hospital.specialties,
            facilities=hospital.facilities,
            ambulance_services=hospital.ambulance_services,
            opening_hours=hospital.opening_hours,
            license_number=hospital.license_number,
            license_expiry_date=hospital.license_expiry_date,
            is_accredited=hospital.is_accredited,
            external_id=hospital.external_id,
            timezone=hospital.timezone,
            is_active=hospital.is_active,
            address=hospital.address,
            city=hospital.city,
            state=hospital.state,
            country=hospital.country,
            zipcode=hospital.zipcode,
            phone_number=hospital.phone_number,
        )
        db.add(new_hospital)
        await db.commit()
        await db.refresh(new_hospital)
        stmt = (
            select(Hospital)
            .options(
                selectinload(Hospital.admin),
                selectinload(Hospital.permissions),
                selectinload(Hospital.hospital_payments)
            )
            .filter(Hospital.id == new_hospital.id)
        )
        result = await db.execute(stmt)
        hospital_with_rel = result.scalars().first()

        # Manually convert nested relationships
        permissions = [PermissionResponse.model_validate(p) for p in getattr(hospital_with_rel, "permissions", [])]
        hospital_payments = [HospitalPaymentResponse.model_validate(hp) for hp in getattr(hospital_with_rel, "hospital_payments", [])]
        hospital_dict = hospital_with_rel.__dict__.copy()
        hospital_dict["permissions"] = permissions
        hospital_dict["hospital_payments"] = hospital_payments

        if hospital_dict.get("logo_url"):
            hospital_dict["logo_presigned_url"] = get_presigned_url(hospital_dict["logo_url"])
        else:
            hospital_dict["logo_presigned_url"] = None

        return HospitalResponse.model_validate(hospital_dict)
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=f"Integrity Error: {str(e)}")


async def get_hospital(db: AsyncSession, hospital_id: int):
    stmt = (
        select(Hospital)
        .options(
            selectinload(Hospital.admin),
            selectinload(Hospital.permissions),
            selectinload(Hospital.hospital_payments)
        )
        .filter(Hospital.id == hospital_id)
    )
    result = await db.execute(stmt)
    hospital = result.scalars().first()
    if not hospital:
        raise HTTPException(status_code=404, detail="Hospital not found")

    permissions = [PermissionResponse.model_validate(p) for p in getattr(hospital, "permissions", [])]
    hospital_payments = [HospitalPaymentResponse.model_validate(hp) for hp in getattr(hospital, "hospital_payments", [])]
    hospital_dict = hospital.__dict__.copy()
    hospital_dict["permissions"] = permissions
    hospital_dict["hospital_payments"] = hospital_payments

    if hospital_dict.get("logo_url"):
        hospital_dict["presigned_logo_url"] = get_presigned_url(hospital_dict["logo_url"])
    else:
        hospital_dict["presigned_logo_url"] = None

    return HospitalResponse.model_validate(hospital_dict)


async def get_hospitals(db: AsyncSession, skip: int = 0, limit: int = 100):
    stmt = (
        select(Hospital)
        .options(
            selectinload(Hospital.admin),
            selectinload(Hospital.permissions),
            selectinload(Hospital.hospital_payments)
        )
        .offset(skip)
        .limit(limit)
    )
    result = await db.execute(stmt)
    hospitals = result.scalars().all()

    hospital_responses = []
    for h in hospitals:
        permissions = [PermissionResponse.model_validate(p) for p in getattr(h, "permissions", [])]
        hospital_payments = [HospitalPaymentResponse.model_validate(hp) for hp in getattr(h, "hospital_payments", [])]
        hospital_dict = h.__dict__.copy()
        hospital_dict["permissions"] = permissions
        hospital_dict["hospital_payments"] = hospital_payments

        if hospital_dict.get("logo_url"):
            hospital_dict["presigned_logo_url"] = get_presigned_url(hospital_dict["logo_url"])
        else:
            hospital_dict["presigned_logo_url"] = None

        hospital_responses.append(HospitalResponse.model_validate(hospital_dict))
    return hospital_responses


async def update_hospital(db: AsyncSession, hospital_id: int, hospital_update: HospitalUpdate):
    stmt = select(Hospital).filter(Hospital.id == hospital_id)
    result = await db.execute(stmt)
    db_hospital = result.scalars().first()
    if not db_hospital:
        raise HTTPException(status_code=404, detail="Hospital not found")

    for key, value in hospital_update.dict(exclude_unset=True).items():
        setattr(db_hospital, key, value)
    await db.commit()
    await db.refresh(db_hospital)
    stmt = (
        select(Hospital)
        .options(
            selectinload(Hospital.admin),
            selectinload(Hospital.permissions),
            selectinload(Hospital.hospital_payments)
        )
        .filter(Hospital.id == db_hospital.id)
    )
    result = await db.execute(stmt)
    hospital_with_rel = result.scalars().first()

    permissions = [PermissionResponse.model_validate(p) for p in getattr(hospital_with_rel, "permissions", [])]
    hospital_payments = [HospitalPaymentResponse.model_validate(hp) for hp in getattr(hospital_with_rel, "hospital_payments", [])]
    hospital_dict = hospital_with_rel.__dict__.copy()
    hospital_dict["permissions"] = permissions
    hospital_dict["hospital_payments"] = hospital_payments

    if hospital_dict.get("logo_url"):
        hospital_dict["presigned_logo_url"] = get_presigned_url(hospital_dict["logo_url"])
    else:
        hospital_dict["presigned_logo_url"] = None

    return HospitalResponse.model_validate(hospital_dict)


async def delete_hospital(db: AsyncSession, hospital_id: int):
    stmt = select(Hospital).filter(Hospital.id == hospital_id)
    result = await db.execute(stmt)
    db_hospital = result.scalars().first()
    if db_hospital:
        await db.delete(db_hospital)
        await db.commit()
    return db_hospital
