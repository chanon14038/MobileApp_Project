from sqlmodel import Field, SQLModel


class DBNotification(SQLModel, table=True):
    __tablename__ = "notification"
    
    id: int = Field(default=None, primary_key=True)
    
    message : str = Field(default=None)