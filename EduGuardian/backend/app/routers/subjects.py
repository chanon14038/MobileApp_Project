from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated

from .. import models

router = APIRouter(prefix="/subject", tags=["subject"])

@router.post("/create")
async def create_subject(
    info: models.CreatedSubject,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    result = await session.exec(
        select(models.DBUser).where(models.DBUser.id == info.teacher_id)
    )
    dbteacher = result.one_or_none()
        
    if dbteacher:
        result = await session.exec(
            select(models.DBStudent).where(models.DBStudent.classroom == info.classroom)
        )
        dbstudents = result.all()
        dbsubject = models.DBSubject.model_validate(info)
        dbsubject.subject = dbteacher.subject
        dbsubject.db_teacher = dbteacher
        dbsubject.db_student = dbstudents
        for student in dbsubject.db_student:
            dbsubject.all_student_id.append(student.student_id)
        
        session.add(dbsubject)
        await session.commit()
        await session.refresh(dbsubject)
        
        return dbsubject

    raise HTTPException(status_code=404, detail="No teacher found")
