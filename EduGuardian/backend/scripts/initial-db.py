import sys
import os
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.dirname(SCRIPT_DIR))

import asyncio
from app import config, models

if __name__ == "__main__":
    settings = config.get_settings()
    models.init_db(settings)
    asyncio.run(models.recreate_table())