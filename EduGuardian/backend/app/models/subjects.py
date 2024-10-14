from typing import Optional
from sqlalchemy import Column, ARRAY

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

import pydantic
from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field, Relationship

from .link import StudentSubjectLink


class BaseSubject(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    subject: str = pydantic.Field(json_schema_extra=dict(example="Math"))
    subject_id: str = pydantic.Field(json_schema_extra=dict(example="math101"))
    classroom: str = pydantic.Field(json_schema_extra=dict(example="1/1"))
    description: str | None = pydantic.Field(json_schema_extra=dict(example="Math for 1/1"))
    

    
class CreatedSubject(BaseSubject):
    pass

class UpdatedSubject(BaseSubject):
    pass

class Subject(BaseSubject):
    students: list[str] | None
    

class DBSubject(BaseSubject, SQLModel, table=True):
    __tablename__ = "subjects"

    id: int = Field(default=None, primary_key=True)
    subject: str = Field(default=None)
    
    teacher_id: Optional[int] = Field(default=None, foreign_key="users.id")
    # all_student_id: list[str] = Field(default=[], sa_column=Column(JSON))

    
    db_student: list["DBStudent"] | None = Relationship(back_populates="db_subject", link_model=StudentSubjectLink)
    db_teacher: Optional["DBUser"] = Relationship(back_populates="db_subject")
    
    


class SubjectList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    subjects: list[Subject]
    page: int
    page_size: int
    size_per_page: int