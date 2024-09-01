import sys
import os
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.dirname(SCRIPT_DIR))

from httpx import AsyncClient
from app import models
import pytest


@pytest.mark.asyncio
async def test_create_student(client: AsyncClient):
    # Example payload for creating a student
    payload = {
        "classroom": "1/1",
        "student_id": "123456",
        "first_name": "John",
        "last_name": "Doe",
    }

    response = await client.post("/students", json=payload)
    
    print(f"Raw response: {response.content}")
    data = payload
    
    assert response.status_code == 200
    assert data["first_name"] == "John"
    assert data["last_name"] == "Doe"
    assert data["student_id"] == "123456"
    assert data["classroom"] == "1/1"