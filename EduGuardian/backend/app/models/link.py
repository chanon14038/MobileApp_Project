from sqlmodel import SQLModel, Field

class StudentSubjectLink(SQLModel, table=True):
    __tablename__ = "student_subjects"

    student_id: str = Field(default=None, foreign_key="students.student_id", primary_key=True)
    subject_id: int = Field(default=None, foreign_key="subjects.id", primary_key=True)
