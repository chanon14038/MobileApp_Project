from fastapi import APIRouter, Depends, HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated

from .. import models
from .. import deps

router = APIRouter(prefix="/subject", tags=["subject"])

@router.post("")
async def create_subject(
    info: models.CreatedSubject,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user)
):      
    result = await session.exec(
        select(models.DBSubject).where((models.DBSubject.subject_id == info.subject_id) & (models.DBSubject.classroom == info.classroom))
    )
    dbsubject = result.one_or_none()
    if dbsubject:
        raise HTTPException(status_code=400, detail="Subject already exists")
    
    
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.classroom == info.classroom)
    )
    dbstudents = result.all()
    dbsubject = models.DBSubject.model_validate(info)
    dbsubject.db_teacher = current_user
    dbsubject.db_student = dbstudents
    
    
    session.add(dbsubject)
    await session.commit()
    await session.refresh(dbsubject)
    
    return dbsubject

@router.get("")
async def get_subjects(
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user)
):
    result = await session.exec(
        select(models.DBSubject).where(models.DBSubject.teacher_id == current_user.id)
    )
    dbsubjects = result.all()
    if not dbsubjects:
        raise HTTPException(status_code=404, detail="Subject not found")
    return dbsubjects

@router.get("/{id}")
async def get_one_subject(
    id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user)
):
    result = await session.exec(
        select(models.DBSubject).where(models.DBSubject.id == id)
    )
    dbsubjects = result.one_or_none()
    if not dbsubjects:
        raise HTTPException(status_code=404, detail="Subject not found")
    return dbsubjects

@router.get("/{id}/students")
async def get_students(
    id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user)
):
    result = await session.exec(
        select(models.DBSubject).where(models.DBSubject.id == id)
    )
    dbsubjects = result.one_or_none()
    if not dbsubjects:
        raise HTTPException(status_code=404, detail="Subject not found")
    
    result = await session.exec(
        select(models.DBStudent).where(models.DBStudent.classroom == dbsubjects.classroom)
    )
    students = result.all()

    if not students:
        raise HTTPException(status_code=404, detail="Students not found")
    return students