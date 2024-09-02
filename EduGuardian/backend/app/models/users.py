import datetime
from typing import Optional

import bcrypt

import pydantic
from pydantic import BaseModel, ConfigDict, EmailStr

import sqlmodel
from sqlmodel import SQLModel, Relationship

from . import classrooms
from . import subjects
from . import students


class BaseUser(BaseModel):
    model_config = ConfigDict(from_attributes=True, populate_by_name=True)
    username: str = pydantic.Field(json_schema_extra=dict(example="somsri"))
    first_name: str = pydantic.Field(json_schema_extra=dict(example="Firstname"))
    last_name: str = pydantic.Field(json_schema_extra=dict(example="Lastname"))
    subject: str = pydantic.Field(json_schema_extra=dict(example="Thai"))
    
    advisor_room: str | None = pydantic.Field(json_schema_extra=dict(example="1/1"))
    

class User(BaseUser):
    id: int
    advisor_room_id: int

    
    last_login_date: datetime.datetime | None = pydantic.Field(default=None)
    register_date: datetime.datetime = pydantic.Field(default_factory=datetime.datetime.now)

class UserList(BaseModel):
    model_config = ConfigDict(from_attributes=True, populate_by_name=True)
    users: list[User]
    
class RegisteredUser(BaseUser):
    password: str = pydantic.Field(json_schema_extra=dict(example="somsri"))



class Login(BaseModel):
    username: str
    password: str

class ChangedPassword(BaseModel):
    current_password: str
    new_password: str

class ResetedPassword(BaseModel):
    email: EmailStr
    citizen_id: str

class UpdatedUser(BaseModel):
    first_name: str | None = pydantic.Field(json_schema_extra=dict(example="Firstname"))
    last_name: str | None = pydantic.Field(json_schema_extra=dict(example="Lastname"))
    subject: str | None = pydantic.Field(json_schema_extra=dict(example="Thai"))
    
    advisor_room: str | None = pydantic.Field(json_schema_extra=dict(example="1/1"))


class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str
    expires_in: int
    expires_at: datetime.datetime
    scope: str
    issued_at: datetime.datetime
    user_id: int | None = None

class DBUser(User,SQLModel,table=True):
    __tablename__ = 'users'
    id: int = sqlmodel.Field(default=None, primary_key=True)

    password : str
    
    advisor_room_id: int | None = sqlmodel.Field(default=None, foreign_key="classrooms.id")
    
    db_classroom: Optional["classrooms.DBClassroom"] = Relationship(back_populates="db_teacher", passive_deletes=True)
    db_subject: list["subjects.DBSubject"] = Relationship(back_populates="db_teacher", passive_deletes=True)
    db_student: list["students.DBStudent"] = Relationship(back_populates="db_teacher", passive_deletes=True)    

    updated_date: datetime.datetime = sqlmodel.Field(default_factory=datetime.datetime.now)
    
    async def get_encrypted_password(self, plain_password):
        return bcrypt.hashpw(
            plain_password.encode("utf-8"), salt=bcrypt.gensalt()
        ).decode("utf-8")

    async def set_password(self, plain_password):
        self.password = await self.get_encrypted_password(plain_password)

    async def verify_password(self, plain_password):
        print(plain_password, self.password)
        return bcrypt.checkpw(
            plain_password.encode("utf-8"), self.password.encode("utf-8")
        )
