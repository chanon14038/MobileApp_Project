from tests import client

def test_get_me():
    response = client.get("/users/me")
    assert response.status_code == 200
    # ตรวจสอบว่าข้อมูลที่ได้ถูกต้อง
    assert "username" in response.json()

def test_get_user_by_id():
    user_id = 1  # กำหนด ID ที่ต้องการทดสอบ
    response = client.get(f"/users/{user_id}")
    if response.status_code == 200:
        assert response.json()["id"] == user_id
    else:
        assert response.status_code == 404

def test_create_user():
    user_data = {
        "username": "testuser",
        "first_name": "Test",
        "last_name": "User",
        "subject": "Math",
        "password": "testpassword",
    }
    response = client.post("/users/create", json=user_data)
    assert response.status_code == 200
    assert response.json()["username"] == "testuser"

def test_change_password():
    password_data = {
        "current_password": "oldpassword",
        "new_password": "newpassword"
    }
    response = client.put("/users/change_password", json=password_data)
    if response.status_code == 200:
        assert response.json()["id"] == 1  # ตรวจสอบ ID ของผู้ใช้
    else:
        assert response.status_code == 401

def test_delete_user():
    user_id = 1  # กำหนด ID ที่ต้องการลบ
    response = client.delete(f"/users/{user_id}")
    if response.status_code == 200:
        assert response.json()["message"] == "delete success"
    else:
        assert response.status_code == 404
