from typing import List, Optional
from sqlalchemy import Column

from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.types import JSON

from pydantic import BaseModel, ConfigDict
from sqlmodel import SQLModel, Field

from .classrooms import ClassRoom


class BaseTeaching(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    subject: str
    id_teacher: int
    classroom: ClassRoom
    
class CreatedTeaching(BaseTeaching):
    pass

class UpdatedTeaching(BaseTeaching):
    pass

class Teaching(BaseTeaching):
    students: list[str] | None
    
class DBTeaching(BaseTeaching, SQLModel, table=True):
    __tablename__ = "teachings"
    
    id: int = Field(default=None, primary_key=True)
    
    # students_id: Optional[List[str]] = Field(default=None, sa_column=Column(MutableList.as_mutable(JSON)))
    students_id: Optional[List[str]] = Field(default_factory=list, sa_column=Column(JSON))


class TeachingList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    Teachings: list[Teaching]
    page: int
    page_size: int
    size_per_page: int