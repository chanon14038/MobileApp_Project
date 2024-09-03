from typing import Optional, List
from sqlalchemy import Column

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

import pydantic
from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field, Relationship

from . import users
from . import students
from . import students

class BaseClassroom(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    classroom: str = pydantic.Field(json_schema_extra=dict(example="1/1"))
    
class CreatedClassroom(BaseClassroom):
    pass

class UpdatedClassroom(BaseClassroom):
    pass

class Classroom(BaseClassroom):
    all_student_id: list[str] | None
    
class DBClassroom(BaseClassroom, SQLModel, table=True):
    __tablename__ = "classrooms"
    
    id: int = Field(default=None, primary_key=True)
    
    # all_student_id: list[str] = Field(default=[], sa_column=Column(JSON))
    
    db_teacher: Optional["DBUser"] | None = Relationship(back_populates="db_classroom", passive_deletes=True)
    db_student: list["DBStudent"] | None = Relationship(back_populates="db_classroom", passive_deletes=True)
    


class ClassroomList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    Classrooms: list[Classroom]
    page: int
    page_size: int
    size_per_page: int