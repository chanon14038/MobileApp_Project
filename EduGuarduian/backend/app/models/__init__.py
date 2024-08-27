from sqlmodel import SQLModel, create_engine, Session

connect_args = {}

engine = create_engine(
    "postgresql+pg8000://postgres:123456@localhost/EduGuarduian",
    echo=True,
    connect_args=connect_args,
)

def init_db():
    # SQLModel.metadata.drop_all(engine)
    SQLModel.metadata.create_all(engine)


def get_session():
    with Session(engine) as session:
        yield session
