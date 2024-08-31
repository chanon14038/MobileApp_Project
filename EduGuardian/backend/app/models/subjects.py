from typing import Optional
from sqlalchemy import Column, ARRAY

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field

from .rooms import Room


class BaseSubject(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    subject: str
    id_teacher: int
    classroom: Room

    sudent_ids =  Column(MutableList.as_mutable(ARRAY(str)))
    
class CreatedSubject(BaseSubject):
    pass

class UpdatedSubject(BaseSubject):
    pass

class Subject(BaseSubject):
    students: list[str] | None
    
class DBSubject(BaseSubject, SQLModel, table=True):
    __tablename__ = "Subjects"

    id: int = Field(default=None, primary_key=True)
    
    # students_id: Optional[List[str]] = Field(default=None, sa_column=Column(MutableList.as_mutable(JSON)))
    # students_id: Optional[list[str]] = Field(default_factory=list, sa_column=Column(JSON))
    


class SubjectList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    subjects: list[Subject]
    page: int
    page_size: int
    size_per_page: int