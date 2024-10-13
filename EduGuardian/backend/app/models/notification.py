from sqlmodel import Field, SQLModel


class DBNotification(SQLModel, table=True):
    id: int = Field(default=None, primary_key=True)
    advisor_room: str = Field(nullable=False)
    message: str = Field(nullable=False)
