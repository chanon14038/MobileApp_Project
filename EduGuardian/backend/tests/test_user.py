from fastapi.testclient import TestClient
from app import models 
import pytest

client = TestClient()
@pytest.mark.asyncio
async def test_get_me():
    response = await client.get("/users/me")
    assert response.status_code == 200
    assert "username" in response.json()

@pytest.mark.asyncio
async def test_get_user_by_id():
    user_id = 1  # กำหนด ID ที่ต้องการทดสอบ
    response = await client.get(f"/users/{user_id}")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        assert response.json()["id"] == user_id

@pytest.mark.asyncio
async def test_create_user():
    user_data = {
        "username": "testuser",
        "first_name": "Test",
        "last_name": "User",
        "subject": "Math",
        "password": "testpassword",
    }
    response = await client.post("/users/create", json=user_data)
    assert response.status_code == 200
    assert response.json()["username"] == "testuser"

@pytest.mark.asyncio
async def test_change_password():
    password_data = {
        "current_password": "oldpassword",
        "new_password": "newpassword"
    }
    response = await client.put("/users/change_password", json=password_data)
    assert response.status_code in [200, 401]
    if response.status_code == 200:
        assert response.json()["id"] == 1  # ตรวจสอบ ID ของผู้ใช้

@pytest.mark.asyncio
async def test_delete_user():
    user_id = 1  # กำหนด ID ที่ต้องการลบ
    response = await client.delete(f"/users/{user_id}")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        assert response.json()["message"] == "delete success"
