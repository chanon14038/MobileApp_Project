from fastapi import APIRouter, Depends, HTTPException, Request, Response, UploadFile, status
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select
import base64

from typing import Annotated

from .. import deps
from .. import models

router = APIRouter(prefix="/users", tags=["users"])


@router.get("/me")
def get_me(current_user: models.User = Depends(deps.get_current_user)) -> models.User:
    if current_user.imageData:
        current_user.imageData = base64.b64encode(current_user.imageData).decode('utf-8')
    
    return current_user


@router.get("/imageProfile")
async def get_image_profile(
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.DBUser = Depends(deps.get_current_user)
):
    if not current_user.imageData:
        raise HTTPException(status_code=404, detail="Image data not found")
    return Response(current_user.imageData, media_type="image/jpeg")
    


@router.put("/imageProfile")
async def upload_image(
    file: UploadFile,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
):
    result = await session.exec(
        select(models.DBUser).where(models.DBUser.id == current_user.id)
    )
    user = result.one_or_none()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this user",
        )
    
    user.imageData = await file.read()
    
    session.add(user)
    await session.commit()
    await session.refresh(user)
    
    raise HTTPException(
        status_code=status.HTTP_200_OK,
        detail="Upload Image successfully",
    )
    

@router.put("/deleteProfile")
async def delete_imageProfile(
    
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
):
    result = await session.exec(
        select(models.DBUser).where(models.DBUser.id == current_user.id)
    )
    user = result.one_or_none()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this user",
        )
    
    user.imageData = None
    
    session.add(user)
    await session.commit()
    await session.refresh(user)
    
    raise HTTPException(
        status_code=status.HTTP_200_OK,
        detail="Delete image profile successfully",
    )

@router.post("/create")
async def create(
    user_info: models.RegisteredUser,
    # classroom: models.ClassRoomInfo,
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> models.User:

    result = await session.exec(
        select(models.DBUser).where(models.DBUser.username == user_info.username)
    )
    user = result.one_or_none()

    if not user:
        result = await session.exec(
            select(models.DBClassroom).where(models.DBClassroom.classroom == user_info.advisor_room)
        )
        dbclassroom = result.one_or_none()
        
        result = await session.exec(
            select(models.DBStudent).where(models.DBStudent.classroom == user_info.advisor_room)
        )
        dbstudents = result.all()
        
        
        dbuser = models.DBUser.model_validate(user_info)
        if dbclassroom:
            dbuser.db_classroom = dbclassroom
        if dbstudents:
            dbuser.db_student = dbstudents
            for student in dbuser.db_student:
                student.advisor = f"{dbuser.first_name} {dbuser.last_name}"
        
        await dbuser.set_password(user_info.password)
        session.add(dbuser)
        await session.commit()
        await session.refresh(dbuser)

        return dbuser
        
    raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="This username is exists.")

   

@router.put("/change_password")
async def change_password(

    password_update: models.ChangedPassword,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.User:
    
    result = await session.exec(
        select(models.DBUser).where(models.DBUser.id == current_user.id)
    )
    db_user = result.one_or_none()

    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this user",
        )

    if not await db_user.verify_password(password_update.current_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect password",
        )
    if db_user:
        await db_user.set_password(password_update.new_password)
        session.add(db_user)
        await session.commit()
        await session.refresh(db_user)
        raise HTTPException(
            status_code=status.HTTP_200_OK,
            detail="Change password successfully",
        )
    



@router.put("/update")
async def update(
    request: Request,
    user_update: models.UpdatedUser,
    # password_update: models.ChangedPassword,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.User:

    result = await session.exec(
        select(models.DBUser).where(models.DBUser.id == current_user.id)
    )
    db_user = result.one_or_none()

    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this user",
        )

    # if not await db_user.verify_password(password_update.current_password):
    #     raise HTTPException(
    #         status_code=status.HTTP_401_UNAUTHORIZED,
            
    #         detail="Incorrect password",
        # )
    if db_user:
        db_user.sqlmodel_update(user_update)
        # await db_user.set_password(password_update.new_password)
        session.add(db_user)
        await session.commit()
        await session.refresh(db_user)


        return db_user


@router.delete("/{user_id}")
async def delete_user(
    user_id: int,
    current_user: Annotated[models.User, Depends(deps.get_current_user)],
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> dict:
    db_user = await session.get(models.DBUser, user_id)
    if db_user:
        await session.delete(db_user)
        await session.commit()
        
        
        return dict(message="delete success")
    raise HTTPException(status_code=404, detail="user not found")

