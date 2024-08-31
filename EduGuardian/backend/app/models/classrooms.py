from typing import Optional, List
from sqlalchemy import Column

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field, Relationship

from .rooms import Room

class BaseClassroom(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    classroom: Room
    
class CreatedClassroom(BaseClassroom):
    teacher_id: int
    pass

class UpdatedClassroom(BaseClassroom):
    pass

class Classroom(BaseClassroom):
    students: list[str] | None
    
class DBClassroom(BaseClassroom, SQLModel, table=True):
    __tablename__ = "classrooms"
    
    id: int = Field(default=None, primary_key=True)
    
    students_id: list = Field(default=[], sa_column=Column(JSON))
    
    teacher: list["DBUser"] = Relationship(back_populates="db_classroom")
    student: list["DBStudent"] = Relationship(back_populates="db_classroom")
    


class ClassroomList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    Classrooms: list[Classroom]
    page: int
    page_size: int
    size_per_page: int