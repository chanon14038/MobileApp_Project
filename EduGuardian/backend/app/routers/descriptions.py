from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated, List

from app import deps

from .. import models

router = APIRouter(prefix="/descriptions", tags=["descriptions"])


@router.post("")
async def create(
    info: models.CreatedDescription,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.student_id == info.student_id)
    )
    dbstudent = result.one_or_none()
    
    if dbstudent:
    
        dbdescription = models.DBDescription.model_validate(info)
        dbdescription.db_student = dbstudent
        dbdescription.first_name = dbstudent.first_name
        dbdescription.last_name = dbstudent.last_name
        
        session.add(dbdescription)
        await session.commit()
        await session.refresh(dbdescription)
        
        return dbdescription
    
    raise HTTPException(status_code=404, detail="Not Found Student")

@router.get("/{student_id}")
async def get_descriptions(
    student_id: str,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user)
):
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.student_id == student_id)
    )
    dbstudent = result.one_or_none()
    if not dbstudent:
        raise HTTPException(status_code=404, detail="Not found Student")
    
    if dbstudent.advisor_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not allowed")
    
    result = await session.exec(
        select(models.DBDescription).where(models.DBDescription.student_id == student_id)
    )
    dbdescriptions = result.all()
    if not dbdescriptions:
        raise HTTPException(status_code=404, detail="Not found Report")
    return dbdescriptions