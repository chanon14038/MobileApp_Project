import pytest
from typing import List

from fastapi import Depends, HTTPException
from sqlalchemy.ext.asyncio.session import AsyncSession

from ..app import deps  # Assuming this is where get_session is defined
from ..app import models  # Assuming this is the parent directory for models and routers

# Fixture to inject a fake AsyncSession object
@pytest.fixture
async def fake_session():
    async def override_get_session():
        # Implement logic to create a fake session for testing
        # This can involve an in-memory database or mocking the session object
        session = AsyncSession()
        yield session
        await session.close()

    deps.get_session = override_get_session
    yield


async def test_get_all_students_empty(fake_session: AsyncSession):
    # Arrange
    async def mock_execute(query):
        return None

    fake_session.exec = mock_execute

    # Act
    with pytest.raises(HTTPException) as excinfo:
        await models.routers.students.get_all_students(fake_session)

    # Assert
    assert excinfo.type == HTTPException
    assert excinfo.value.status_code == 404
    assert str(excinfo.value.detail) == "No students found"


async def test_get_all_students_with_data(fake_session: AsyncSession):
    # Arrange
    expected_students = [
        models.DBStudent(student_id="1", first_name="John", last_name="Doe"),
        models.DBStudent(student_id="2", first_name="Jane", last_name="Doe"),
    ]

    async def mock_execute(query):
        return expected_students

    fake_session.exec = mock_execute

    # Act
    students = await models.routers.students.get_all_students(fake_session)

    # Assert
    assert students == expected_students


async def test_get_student_by_id_not_found(fake_session: AsyncSession):
    # Arrange
    async def mock_get(model, student_id):
        return None

    fake_session.get = mock_get

    student_id = "unknown"

    # Act
    with pytest.raises(HTTPException) as excinfo:
        await models.routers.students.get_student_by_id(student_id, fake_session)

    # Assert
    assert excinfo.type == HTTPException
    assert excinfo.value.status_code == 404
    assert f"Student with id {student_id} not found" in str(excinfo.value.detail)


async def test_get_student_by_id_found(fake_session: AsyncSession):
    # Arrange
    expected_student = models.DBStudent(student_id="1", first_name="John", last_name="Doe")

    async def mock_get(model, student_id):
        if student_id == "1":
            return expected_student
        return None

    fake_session.get = mock_get

    student_id = "1"

    # Act
    student = await models.routers.students.get_student_by_id(student_id, fake_session)

    # Assert
    assert student == expected_student


async def test_create_student(fake_session: AsyncSession):
    # Arrange
    new_student_info = models.CreatedStudent(
        first_name="John", last_name="Doe", classroom="1/1"
    )

    async def mock_execute(query):
        # Simulate successful classroom lookup and student creation
        return True

    fake_session.exec = mock_execute

    # Act
    created_student = await models.routers.students.create(new_student_info, fake_session)

    # Assert
    assert created_student.student_id is not None
    assert created_student.first_name == new_student_info.first_name
    assert created_student.last_name == new_student_info.last_name
    assert created_student.classroom == new_student_info.classroom


async def test_update_student_not_found(fake_session: AsyncSession):
    # Arrange
    student_id = "unknown"