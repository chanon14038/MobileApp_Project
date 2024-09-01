import sys
import os
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.dirname(SCRIPT_DIR))

from httpx import AsyncClient
from app import models
import pytest
import json

@pytest.mark.asyncio
async def test_create_student(client: AsyncClient):
    # Example payload for creating a student
    payload = {
        "first_name": "string",
        "last_name": "string",
        "classroom": "1/1",
        "student_id": "123456"
    }

    response = await client.post("/students", json=payload)
    
    data = response.json
    
    assert response.status_code == 200
    assert data["first_name"] == "string"
    assert data["last_name"] == "string"
    assert data["student_id"] == "123456"
    assert data["classroom"] == "1/1"