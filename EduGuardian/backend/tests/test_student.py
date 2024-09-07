import sys
import os
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.dirname(SCRIPT_DIR))

import pytest
from httpx import ASGITransport, AsyncClient
import pytest

@pytest.mark.asyncio
async def test_some_asyncio_code():
