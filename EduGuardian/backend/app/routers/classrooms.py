from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated

from .. import models

router = APIRouter(prefix="/classroom", tags=["classroom"])

@router.post("/create")
async def create_classroom(
    info: models.CreatedClassroom,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.classroom == info.classroom)
    )
    students = result.all()

    if not students:
        raise HTTPException(status_code=404, detail="No students found for the given classroom")

    student_ids = [student.student_id for student in students]

    # เพิ่ม student_ids ลงใน DBClassroom (ตัวอย่างการอัพเดต)
    Classroom = models.DBClassroom(
        subject=info.subject,
        id_teacher=info.id_teacher,
        classroom=info.classroom,
        students_id = student_ids,
    )
    session.add(Classroom)
    await session.commit()

    return Classroom
