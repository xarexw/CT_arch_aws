import json
import boto3
from botocore.exceptions import ClientError
dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        def transform_body(item):
            return {
                "id": item.get("id", {}).get("S", ""),
                "firstName": item.get("firstName", {}).get("S", ""),
                "lastName": item.get("lastName", {}).get("S", "")
            }

        
        all_items = []
        last_evaluated_key = None

        while True:
            scan_params = {
                'TableName': 'authors'
            }

            if last_evaluated_key:
                scan_params['ExclusiveStartKey'] = last_evaluated_key

            response = dynamodb.scan(**scan_params)
            all_items.extend(response.get('Items', []))
            last_evaluated_key = response.get('LastEvaluatedKey')

            if not last_evaluated_key:
                break
            
        transformed_items = [transform_body(item) for item in all_items]
        pretty_body = json.dumps(transformed_items, indent = 4, ensure_ascii=False)

        return {
            'statusCode': 200,
            'body': pretty_body,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Methods': '*'
            }
        }

    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': e.response['Error']['Message']}),
            'headers': {
                'Content-Type': 'application/json'
            }
        }

