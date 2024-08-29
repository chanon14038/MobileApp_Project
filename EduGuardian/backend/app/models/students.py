from typing import List, Optional
from sqlalchemy import Column

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

from enum import Enum
from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field

class ClassRoom(Enum):
    one_one = 101
    one_two = 102
    one_three = 103
    two_one = 201
    two_two = 202
    two_three = 203
    three_one = 301
    three_two = 302
    three_three = 303
    four_one = 401
    four_two = 402
    four_three = 403
    five_one = 501
    five_two = 502
    five_three = 503
    six_one = 601
    six_two = 602
    six_three = 603

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