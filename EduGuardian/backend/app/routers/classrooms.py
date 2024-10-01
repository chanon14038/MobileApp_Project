from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated

from .. import models

router = APIRouter(prefix="/classroom", tags=["classroom"])

@router.get("")
async def get_classroom(
    session: Annotated[AsyncSession, Depends(models.get_session)]
) :
    result = await session.exec(
        select(models.DBClassroom)
    )
    classrooms = result.all()

    if not classrooms:
        raise HTTPException(
            status_code=404,
            detail="No classrooms found",
        )

    return classrooms

@router.post("")
async def create_classroom(
    info: models.CreatedClassroom,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    result = await session.exec(
        select(models.DBClassroom).where(models.DBClassroom.classroom == info.classroom)
    )
    classroom= result.one_or_none()
    
    if not classroom:
        result = await session.exec(
            select(models.DBStudent).where(models.DBStudent.classroom == info.classroom)
        )
        dbstudents = result.all()
        
        result = await session.exec(
            select(models.DBUser).where(models.DBUser.advisor_room == info.classroom)
        )
        dbteacher = result.one_or_none()

        dbclassroom = models.DBClassroom.model_validate(info)
        if dbstudents:
            dbclassroom.db_student = dbstudents
        if dbteacher:
            dbclassroom.db_teacher = dbteacher
        
        session.add(dbclassroom)
        await session.commit()
        await session.refresh(dbclassroom)
        
        return dbclassroom
        
    raise HTTPException(status_code=409, detail="Classroom already exists")


@router.delete("/{classroom_id}")
async def delete_classroom(
    classroom_id: int,
    # current_user: Annotated[models.User, Depends(deps.get_current_user)],
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> dict:
    result = await session.exec(
        select(models.DBClassroom).where(models.DBClassroom.id == classroom_id)
    )
    dbclassroom = result.one_or_none()
    if dbclassroom :
        await session.delete(dbclassroom)
        await session.commit()
        
        return dict(message="delete success")
    raise HTTPException(status_code=404, detail=" not found")   