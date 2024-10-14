from fastapi import FastAPI, APIRouter, Depends
from fastapi.testclient import TestClient
from unittest.mock import patch
from app.models import BaseUser 


# mock user data
mock_user_data = {
    "username": "somsri",
    "first_name": "Firstname",
    "last_name": "Lastname",
    "subject": "Thai",
    "phone_number": "0891234567",
    "email": "someric@example.com",
    "advisor_room": "1/1",
}

app = FastAPI()
router = APIRouter(prefix="/users", tags=["users"])

# ฟังก์ชันจำลองสำหรับรับผู้ใช้ปัจจุบัน
def get_current_user():
    return BaseUser(**mock_user_data)

@router.get("/me", response_model=BaseUser)
def get_me(current_user: BaseUser = Depends(get_current_user)) -> BaseUser:
    return current_user
app.include_router(router)

# Testing--------------------------------------------------------------------------------------------------------------------------

client = TestClient(app)

def test_get_me():
    response = client.get("/users/me")
    assert response.status_code == 200
    assert response.json() == mock_user_data  
