from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import func, extract
from datetime import datetime
from app.database import get_db
from app.models.hospital import Hospital
from app.models.user import User
from app.models.permission import Permission
from app.models.role import Role
from app.models.hospital_payment import HospitalPayment

router = APIRouter(prefix="/admin/dashboard", tags=["Admin Dashboard"])

@router.get("/summary")
async def get_summary(db: AsyncSession = Depends(get_db)):
    hospitals = await db.execute(func.count(Hospital.id))
    users = await db.execute(func.count(User.id))
    revenue = await db.execute(func.coalesce(func.sum(HospitalPayment.amount), 0))
    permission_groups = await db.execute(func.count(Role.id))
    notifications = 3  # Replace with real logic if you have notifications table
    growth = 7.2       # Replace with real calculation

    return {
        "hospitals": hospitals.scalar(),
        "users": users.scalar(),
        "revenue": float(revenue.scalar()),
        "permissionGroups": permission_groups.scalar(),
        "notifications": notifications,
        "growth": growth
    }

@router.get("/revenue")
async def get_monthly_revenue(db: AsyncSession = Depends(get_db)):
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    serviceRevenue = []
    productRevenue = []
    usersTrend = []

    for i, month in enumerate(months, start=1):
        # Example: sum payments for each month
        service = await db.execute(
            func.coalesce(
                func.sum(HospitalPayment.amount).filter(extract('month', HospitalPayment.date) == i), 0
            )
        )
        serviceRevenue.append(float(service.scalar()))
        # For demo, productRevenue and usersTrend are mocked
        productRevenue.append(5000 + i * 1000)
        usersTrend.append(300 + i * 100)

    return {
        "months": months,
        "serviceRevenue": serviceRevenue,
        "productRevenue": productRevenue,
        "usersTrend": usersTrend
    }

@router.get("/permission-groups")
async def get_permission_groups(db: AsyncSession = Depends(get_db)):
    roles = await db.execute(
        select(Role.name, func.count(User.id)).join(User, User.role_id == Role.id).group_by(Role.name)
    )
    return [{"role": name, "users": count} for name, count in roles.all()]

@router.get("/permissions-distribution")
async def get_permissions_distribution(db: AsyncSession = Depends(get_db)):
    roles = await db.execute(
        select(Role.name, func.count(User.id)).join(User, User.role_id == Role.id).group_by(Role.name)
    )
    data = roles.all()
    return {
        "labels": [name for name, _ in data],
        "data": [count for _, count in data]
    }

@router.get("/recent-activities")
async def get_recent_activities():
    # Replace with real query from your audit/activity log table
    return [
        {
            "hospital": "City Hospital",
            "action": "User Added",
            "time": "2025-06-16T10:00:00Z",
            "status": "Completed"
        },
        {
            "hospital": "Metro Hospital",
            "action": "Permission Updated",
            "time": "2025-06-15T15:30:00Z",
            "status": "Completed"
        }
    ]