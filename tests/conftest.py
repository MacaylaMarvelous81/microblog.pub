from typing import Generator

import pytest
import pytest_asyncio
from fastapi.testclient import TestClient

from microblogpub.app.database import Base
from microblogpub.app.database import async_engine
from microblogpub.app.database import async_session
from microblogpub.app.database import engine
from microblogpub.app.main import app
from tests.factories import _Session


@pytest_asyncio.fixture
async def async_db_session():
    async with async_session() as session:
        async with async_engine.begin() as conn:
            await conn.run_sync(Base.metadata.create_all)
        yield session
        async with async_engine.begin() as conn:
            await conn.run_sync(Base.metadata.drop_all)


@pytest.fixture
def db() -> Generator:
    Base.metadata.create_all(bind=engine)
    with _Session() as db_session:
        try:
            yield db_session
        finally:
            db_session.close()
            Base.metadata.drop_all(bind=engine)


@pytest.fixture
def client(db) -> Generator:
    with TestClient(app, follow_redirects=False) as c:
        yield c
