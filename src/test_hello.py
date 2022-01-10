import pytest

from .hello import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client
    
def test_hello(client):
    rv = client.get('/')
    assert b'Hello, World!' in rv.data