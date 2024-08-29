from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated

from .. import models

router = APIRouter(prefix="/teaching", tags=["teaching"])

@router.post("/assign_students")
async def assign_students(
    info: models.CreatedTeaching,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    # ค้นหานักเรียนที่อยู่ในห้องเรียนที่กำหนด
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.classroom == info.classroom)
    )
    students = result.all()

    if not students:
        raise HTTPException(status_code=404, detail="No students found for the given classroom")

    student_ids = [student.student_id for student in students]

    # เพิ่ม student_ids ลงใน DBTeaching (ตัวอย่างการอัพเดต)
    teaching = models.DBTeaching(
        subject=info.subject,
        id_teacher=info.id_teacher,
        classroom=info.classroom,
        students_id = student_ids,
    )
    session.add(teaching)
    await session.commit()

    return teaching
