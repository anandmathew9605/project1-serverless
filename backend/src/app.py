import boto3
import json
import os

TABLE_NAME = os.environ.get("TABLE_NAME", "project1-serverless-visitor-dev")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(TABLE_NAME)


def lambda_handler(event, context):
    method = event.get("requestContext", {}).get("http", {}).get("method", "GET")

    try:
        if method == "POST":
            # increment visitor count
            response = table.update_item(
                Key={"UserID": "visitor_count"},
                UpdateExpression="SET #c = if_not_exists(#c, :start) + :inc",
                ExpressionAttributeNames={"#c": "count"},
                ExpressionAttributeValues={":start": 0, ":inc": 1},
                ReturnValues="UPDATED_NEW"
            )
            count = int(response["Attributes"]["count"])
            message = "Visitor count incremented"

        else:
   
   
            # fetch current count (GET)
            response = table.get_item(Key={"UserID": "visitor_count"})
            count = int(response.get("Item", {}).get("count", 0))
            message = "Visitor count fetched"

        body = {"message": message, "count": count}
        status = 200

    except Exception as e:
        body = {"error": str(e)}
        status = 500

    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps(body)
    }
