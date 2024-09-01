from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated, List

from app import deps

from .. import models

router = APIRouter(prefix="/students", tags=["students"])


@router.post("/create")
async def create(
    info: models.CreatedStudent,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    ):
    
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.student_id == info.student_id)
    )
    dbstudent = result.one_or_none()
    
    if not dbstudent:
        result = await session.exec(
            select(models.DBClassroom).where(models.DBClassroom.classroom == info.classroom)
        )
        dbclassroom = result.one_or_none()
        
        result = await session.exec(
            select(models.DBUser).where(models.DBUser.advisor_room == info.classroom)
        )
        dbadvisor = result.one_or_none()
        
        result = await session.exec(
            select(models.DBSubject).where(models.DBSubject.classroom == info.classroom)
        )
        dbsubject = result.all()
    
        dbstudent = models.DBStudent.model_validate(info)
        if dbclassroom:
            dbstudent.db_classroom = dbclassroom
        if dbadvisor:
            dbstudent.db_teacher = dbadvisor
            dbstudent.advisor = f"{dbadvisor.first_name} {dbadvisor.last_name}"
            
        if dbsubject:
            dbstudent.db_subject = dbsubject
            # for subject in dbstudent.db_subject:
            #     # subject.db_student = dbstudent
            #     subject.all_student_id.append(dbstudent.student_id)
        
            
        session.add(dbstudent)
        await session.commit()
        await session.refresh(dbstudent)
        
        return dbstudent

    raise HTTPException(status_code=409, detail="Student ID already exists")

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


@router.put("/update_student")
async def update_student(
    info: models.UpdatedStudent,
    student_id: str,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.student_id == student_id)
    )
    db_student = result.one_or_none()
    
    if db_student:
        db_student.sqlmodel_update(info)
        session.add(db_student)
        await session.commit()
        await session.refresh(db_student)
        
        return db_student
    raise HTTPException(status_code=404, detail="not found Student")