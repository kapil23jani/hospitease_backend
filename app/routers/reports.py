from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Dict, Any
from sqlalchemy.orm import Session
from sqlalchemy import select, and_, or_, insert, update, delete
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db 

from app.models import Patient, Appointment, Doctor
from app.models.report import Report

router = APIRouter()

MODEL_MAP = {
    "Patient": Patient,
    "Appointment": Appointment,
    "Doctor": Doctor
}

class Condition(BaseModel):
    group: str
    column: str
    operator: str
    value: Any

class Group(BaseModel):
    conditions: List[Condition]
    groupOperator: str

class ReportRequest(BaseModel):
    title: str
    type: str
    dateFrom: str
    dateTo: str
    groups: List[Group]
    betweenGroupsOperator: str
    format: str

def build_condition(model, cond: Condition):
    col = getattr(model, cond.column)
    op = cond.operator
    val = cond.value
    if op == "=":
        return col == val
    elif op == "!=":
        return col != val
    elif op == ">":
        return col > val
    elif op == "<":
        return col < val
    elif op == "LIKE":
        return col.like(f"%{val}%")
    else:
        raise HTTPException(status_code=400, detail=f"Unsupported operator: {op}")

def clean_row(row):
    d = dict(row.__dict__)
    d.pop('_sa_instance_state', None)
    return d

@router.post("/api/reports/generate")
async def generate_report(report: ReportRequest, db: AsyncSession = Depends(get_db)):
    results = []
    for group in report.groups:
        conditions = []
        for cond in group.conditions:
            model = MODEL_MAP.get(cond.group)
            if not model:
                raise HTTPException(status_code=400, detail=f"Unknown model: {cond.group}")
            conditions.append(build_condition(model, cond))
        if group.groupOperator == "AND":
            group_expr = and_(*conditions)
        elif group.groupOperator == "OR":
            group_expr = or_(*conditions)
        else:
            raise HTTPException(status_code=400, detail=f"Unknown groupOperator: {group.groupOperator}")
        model = MODEL_MAP.get(group.conditions[0].group)
        stmt = select(model).where(group_expr)
        result = await db.scalars(stmt)
        results.append(set(result.all()))
    if report.betweenGroupsOperator == "AND":
        final_set = set.intersection(*results)
    elif report.betweenGroupsOperator == "OR":
        final_set = set.union(*results)
    else:
        raise HTTPException(status_code=400, detail=f"Unknown betweenGroupsOperator: {report.betweenGroupsOperator}")

    # Clean rows for JSON serialization
    data = [clean_row(row) for row in final_set]

    new_report = Report(
        title=report.title,
        type=report.type,
        date_from=report.dateFrom,
        date_to=report.dateTo,
        criteria=report.dict(),
        result=data
    )
    db.add(new_report)
    await db.commit()
    await db.refresh(new_report)

    return {
        "status": "success",
        "report_id": new_report.id,
        "data": data,
        "criteria": report.dict()
    }

@router.get("/api/reports/{report_id}")
async def get_report(report_id: int, db: AsyncSession = Depends(get_db)):
    stmt = select(Report).where(Report.id == report_id)
    result = await db.scalars(stmt)
    report = result.first()
    if not report:
        raise HTTPException(status_code=404, detail="Report not found")
    return {
        "status": "success",
        "report": {
            "id": report.id,
            "title": report.title,
            "type": report.type,
            "date_from": report.date_from,
            "date_to": report.date_to,
            "criteria": report.criteria,
            "result": report.result,
            "created_at": report.created_at
        }
    }

@router.get("/api/reports")
async def list_reports(db: AsyncSession = Depends(get_db)):
    stmt = select(Report)
    result = await db.scalars(stmt)
    reports = result.all()
    return {
        "status": "success",
        "reports": [
            {
                "id": r.id,
                "title": r.title,
                "type": r.type,
                "date_from": r.date_from,
                "date_to": r.date_to,
                "created_at": r.created_at
            } for r in reports
        ]
    }

@router.put("/api/reports/{report_id}")
async def update_report(report_id: int, update_data: dict, db: AsyncSession = Depends(get_db)):
    stmt = update(Report).where(Report.id == report_id).values(**update_data).execution_options(synchronize_session="fetch")
    await db.execute(stmt)
    await db.commit()
    return {"status": "success", "message": "Report updated"}

@router.delete("/api/reports/{report_id}")
async def delete_report(report_id: int, db: AsyncSession = Depends(get_db)):
    stmt = delete(Report).where(Report.id == report_id)
    await db.execute(stmt)
    await db.commit()
    return {"status": "success", "message": "Report deleted"}