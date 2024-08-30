from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated, List

from app import deps

from .. import models

router = APIRouter(prefix="/students", tags=["students"])

@router.get("/", response_model=List[models.DBStudent])
async def get_all_students(
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> List[models.DBStudent]:
    # Select all students from the DBStudent table
    result = await session.exec(select(models.DBStudent))
    students = result.all()

    # Check if the list of students is empty
    if not students:
        raise HTTPException(
            status_code=404,
            detail="No students found",
        )
    
    return students

@router.get("/{student_id}", response_model=models.DBStudent)
async def get_student_by_id(
    student_id: str,
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> models.DBStudent:
    # ค้นหานักเรียนโดย student_id
    student = await session.get(models.DBStudent, student_id)
    
    if not student:
        raise HTTPException(
            status_code=404,
            detail=f"Student with id {student_id} not found",
        )
    
    return student


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