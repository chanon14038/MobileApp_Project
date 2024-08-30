from typing import List, Optional
from sqlalchemy import Column, Integer

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field, Relationship

from .classrooms import ClassRoom

class BaseStudent(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    first_name: str
    last_name: str
    

    
class CreatedStudent(BaseStudent):
    student_id: str
    classroom: ClassRoom | None

class UpdatedStudent(BaseStudent):
    pass

class Student(BaseStudent):
    student_id: str
    
class DBStudent(BaseStudent, SQLModel, table=True):
    __tablename__ = "students"
    
    first_name: str | None = Field(default=None)
    last_name: str | None = Field(default=None)
    
    student_id: str = Field(default=None, primary_key=True)
    
    classroom: ClassRoom = Field(default=None)
    
    descriptions: List["DBDescription"] = Relationship(back_populates="student")

class StudentList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    students: list[Student]
    page: int
    page_size: int
    size_per_page: int