import datetime
from typing import Optional

import bcrypt

import pydantic
from pydantic import BaseModel, ConfigDict, EmailStr

import sqlmodel
from sqlmodel import SQLModel


class BaseUser(BaseModel):
    model_config = ConfigDict(from_attributes=True, populate_by_name=True)
    username: str = pydantic.Field(example="somsri")
    first_name: str = pydantic.Field(example="Firstname")
    last_name: str = pydantic.Field(example="Lastname")
    year: int = pydantic.Field(example=1)
    room: int = pydantic.Field(example=1)
    subject: str = pydantic.Field(example="Thai")

class User(BaseUser):
    id: int
    
    last_login_date: datetime.datetime | None = pydantic.Field(default=None)
    register_date: datetime.datetime = pydantic.Field(default_factory=datetime.datetime.now)

class UserList(BaseModel):
    model_config = ConfigDict(from_attributes=True, populate_by_name=True)
    users: list[User]
    
class RegisteredUser(BaseUser):
    password: str = pydantic.Field(example="somsri")

class Login(BaseModel):
    username: str
    password: str

class ChangedPassword(BaseModel):
    current_password: str
    new_password: str

class ResetedPassword(BaseModel):
    email: EmailStr
    citizen_id: str

class UpdatedUser(BaseUser):
    pass

class DBUser(User,SQLModel,table=True):
    __tablename__ = 'db_users'
    id: int | None = sqlmodel.Field(default=None, primary_key=True)

    password : str

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
