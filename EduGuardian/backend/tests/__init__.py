from fastapi.testclient import TestClient
from app.models import users

client = TestClient(users)
