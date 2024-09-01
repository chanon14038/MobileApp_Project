from . import authentication
from . import root
from . import users
from . import students
from . import descriptions
from . import classrooms
from . import subjects

def init_router(app):
    app.include_router(root.router)
    app.include_router(authentication.router)
    app.include_router(users.router)
    app.include_router(students.router)
    app.include_router(descriptions.router)
    app.include_router(classrooms.router)
    app.include_router(subjects.router)
