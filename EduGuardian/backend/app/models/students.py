from typing import List, Optional
from sqlalchemy import Column

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field

from .classrooms import ClassRoom

class BaseStudent(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    name: str
    student_id: str
    

    
class CreatedStudent(BaseStudent):
    classroom: ClassRoom | None
    pass

class UpdatedStudent(BaseStudent):
    pass

class Student(BaseStudent):
    description: list[str] | None
    pass
    
class DBStudent(BaseStudent, SQLModel, table=True):
    __tablename__ = "students"
    
    student_id: str | None = Field(default=None, primary_key=True)
    
    classroom: ClassRoom = Field(default=None)
    
    description: Optional[List[str]] = Field(default=None, sa_column=Column(MutableList.as_mutable(JSON)))


class StudentList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    students: list[Student]
    page: int
    page_size: int
    size_per_page: int