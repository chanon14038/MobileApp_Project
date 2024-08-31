from typing import Optional
from sqlalchemy import Column, Integer

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field, Relationship

from .rooms import Room

class BaseStudent(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    first_name: str
    last_name: str

    classroom: Room | None
    

    
class CreatedStudent(BaseStudent):
    student_id: str

class UpdatedStudent(BaseStudent):
    pass

class Student(BaseStudent):
    student_id: str
    
class DBStudent(BaseStudent, SQLModel, table=True):
    __tablename__ = "students"
    
    first_name: str | None = Field(default=None)
    last_name: str | None = Field(default=None)
    
    student_id: str = Field(default=None, primary_key=True)
    
    classroom: Room = Field(default=None)
    
    
    classroom: Room = Field(default=None)
    
    classroom_id: int = Field(default=None, foreign_key="classrooms.id")
    db_classroom: Optional["DBClassroom"] = Relationship(back_populates="student")
    
    descriptions: list["DBDescription"] = Relationship(back_populates="student")

class StudentList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    students: list[Student]
    page: int
    page_size: int
    size_per_page: int