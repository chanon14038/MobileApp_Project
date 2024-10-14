from fastapi import FastAPI, APIRouter, Query, HTTPException
from fastapi.testclient import TestClient
from pydantic import BaseModel
from typing import Dict, Optional
from datetime import datetime, timedelta, timezone
from app.config import Settings
from app.security import create_access_token, create_refresh_token
from app.models import Login
app = FastAPI()

router = APIRouter()


@router.post("/login")
def login(login_data: Login):
    # ใช้ค่าจริงในการตรวจสอบล็อกอิน
    if login_data.username == "somsri" and login_data.password == "somsri":
        # สร้าง access token โดยไม่ต้องระบุ role
        access_token = create_access_token({"username": login_data.username})
        refresh_token = create_refresh_token({"username": login_data.username})
        return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")

app.include_router(router)


# Testing--------------------------------------------------------------------------------------------------------------------------

client = TestClient(app)

def test_login_success():
    # ทดสอบการล็อกอินสำเร็จ
    response = client.post("/login", json={"username": "somsri", "password": "somsri"})
    assert response.status_code == 200
    json_response = response.json()
    assert "access_token" in json_response
    assert "refresh_token" in json_response
    assert json_response["token_type"] == "bearer"

def test_login_failure():
    # ทดสอบการล็อกอินล้มเหลวเมื่อใส่รหัสผ่านผิด
    response = client.post("/login", json={"username": "somsri", "password": "wrongpassword"})
    assert response.status_code == 401
    assert response.json() == {"detail": "Invalid credentials"}

if __name__ == "__main__":
    test_login_success()
    test_login_failure()