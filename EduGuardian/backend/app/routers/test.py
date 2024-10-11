import jwt

secret_key = "secret"  # ต้องใช้ secret key เดียวกันที่ใช้ใน FastAPI
token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImV4cCI6MTcyODUxNzI1Nn0.a0bMl1rvAohfMMRkk6hmiB9W4oC9WyYbPHLQt7oawBk"
try:
    payload = jwt.decode(token, secret_key, algorithms=["HS256"])
    print(payload)
except jwt.ExpiredSignatureError:
    print("Token expired")
except jwt.InvalidTokenError:
    print("Invalid token")