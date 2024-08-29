from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated

from .. import models

router = APIRouter(prefix="/students", tags=["students"])

@router.post("/create")
async def create(
    student_info: models.CreatedStudent,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    
    dbstudent = models.DBStudent.model_validate(student_info)
    
    session.add(dbstudent)
    await session.commit()
    await session.refresh(dbstudent)
    

    return dbstudent

@router.put("/add_description")
async def add_description(
    student_id: str,
    description: str,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.student_id == student_id)
    )
    db_student = result.one_or_none()
    
    if db_student:

        db_student.description.append(description)
        
        db_student.sqlmodel_update(db_student)
        session.add(db_student)
        await session.commit()
        await session.refresh(db_student)
        
        return db_student
    raise HTTPException(status_code=404, detail="Item not found")