import json
import app   

def test_lambda_handler():
    # Simulate an API Gateway event
    event = {"requestContext": {"http": {"method": "GET"}}}
    context = {}
    result = app.lambda_handler(event, context)
    
    # Basic sanity checks
    assert isinstance(result, dict)
    assert result.get("statusCode") == 200
    body = json.loads(result.get("body"))
    assert "message" in body
