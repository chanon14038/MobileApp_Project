from typing import Optional, List
from sqlalchemy import Column

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field, Relationship

from .class_rooms import ClassRoom

class BaseClassroom(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    classroom: ClassRoom
    
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
    
    students_id: Optional[List[str]] = Field(default_factory=list, sa_column=Column(JSON))
    
    user: "DBUser" = Relationship(back_populates="classrooms")
    


class ClassroomList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    Classrooms: list[Classroom]
    page: int
    page_size: int
    size_per_page: int