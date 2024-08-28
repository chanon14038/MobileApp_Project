from . import authentication
from . import root
from . import users

def init_router(app):
    app.include_router(root.router)
    app.include_router(authentication.router)
    # app.include_router(users.router)
