from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated, List

from app import deps

from .. import models

router = APIRouter(prefix="/descriptions", tags=["descriptions"])


@router.post("/create")
async def create(
    info: models.CreatedDescription,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.student_id == info.student_id)
    )
    dbstudent = result.one_or_none()
    
    
    dbdescription = models.DBDescription.model_validate(info)
    dbdescription.db_student = dbstudent
    dbdescription.db_student = dbstudent.classroom
    dbdescription.first_name = dbstudent.first_name
    dbdescription.last_name = dbstudent.last_name
    
    session.add(dbdescription)
    await session.commit()
    await session.refresh(dbdescription)
    

    return dbdescription