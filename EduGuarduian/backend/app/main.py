# main.py

from fastapi import FastAPI


engine = create_engine(
    "postgresql+pg8000://postgres:123456@localhost/digimondb",
    echo=True,
    connect_args=connect_args,
)


app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}


