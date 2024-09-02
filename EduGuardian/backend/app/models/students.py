from typing import Optional
from sqlalchemy import Column, Integer

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

import pydantic
from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field, Relationship

from .link import StudentSubjectLink
from . import users
from . import subjects
from . import classrooms
from . import descriptions

class BaseStudent(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    first_name: str
    last_name: str

    classroom: str | None = pydantic.Field(json_schema_extra=dict(example="1/1"))
    

    
class CreatedStudent(BaseStudent):
    student_id: str

class UpdatedStudent(BaseStudent):
    pass

class Student(BaseStudent):
    student_id: str
    
    
 
class DBStudent(BaseStudent, SQLModel, table=True):
    __tablename__ = "students"
    
    student_id: str = Field(default=None, primary_key=True)
    
    first_name: str | None = Field(default=None)
    last_name: str | None = Field(default=None)
    
    advisor: str | None= Field(default=None)
    
    advisor_id: int | None = Field(default=None, foreign_key="users.id")
    
    classroom_id: int | None = Field(default=None, foreign_key="classrooms.id")
    
    db_classroom: Optional["classrooms.DBClassroom"] = Relationship(back_populates="db_student", passive_deletes=True)
    
    db_descriptions: list["descriptions.DBDescription"] = Relationship(back_populates="db_student", cascade_delete=True)
    db_subject: list["subjects.DBSubject"] | None = Relationship(back_populates="db_student", link_model=StudentSubjectLink)

    db_teacher: Optional["users.DBUser"] = Relationship(back_populates="db_student")

class StudentList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    students: list[Student]
    page: int
    page_size: int
    size_per_page: int