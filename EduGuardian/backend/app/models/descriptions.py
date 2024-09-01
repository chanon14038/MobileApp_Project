from typing import List, Optional
from sqlalchemy import Column

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field, Relationship

class BaseDescription(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    student_id: str
    description: str
    

class CreatedDescription(BaseDescription):
    pass

class UpdatedDescription(BaseDescription):
    pass

class Description(BaseDescription):
    id : int
    student_id: str
    
    
class DBDescription(BaseDescription, SQLModel, table=True):
    __tablename__ = "descriptions"
    
    id: int = Field(default=None, primary_key=True)
    
    first_name: str = Field(default=None)
    last_name: str = Field(default=None)
    
    student_id: str = Field(default=None, foreign_key="students.student_id")

    db_student: Optional["DBStudent"] = Relationship(back_populates="db_descriptions")
    

class DescriptionList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    descriptions: list[Description]
    page: int
    page_size: int
    size_per_page: int