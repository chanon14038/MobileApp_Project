# ssl patch
from gevent import monkey
from fastapi.middleware.cors import CORSMiddleware


from fastapi import FastAPI
from contextlib import asynccontextmanager

from . import config
from . import models

from . import routers



# @asynccontextmanager
# async def lifespan(app: FastAPI):
#     yield
#     if models.engine is not None:
#         # Close the DB connection
#         await models.close_session()


# def create_app(settings=None):
#     if not settings:
#         settings = config.get_settings()

#     app = FastAPI(lifespan=lifespan)

#     models.init_db(settings)

#     routers.init_router(app)
#     return app

def create_app():
    settings = config.get_settings()
    app = FastAPI()
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    models.init_db(settings)

    routers.init_router(app)

    @app.on_event("startup")
    async def on_startup():
        await models.recreate_table()

    return app