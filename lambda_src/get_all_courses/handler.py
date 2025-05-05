import json
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        authors_response = dynamodb.scan(TableName='authors')
        authors = {
            item['id']['S']: f"{item.get('firstName', {}).get('S', '')} {item.get('lastName', {}).get('S', '')}".strip()
            for item in authors_response.get('Items', [])
        }


        def transform_body(item):
            author_id = item.get('author_id', {}).get('S', None)
            author_name = authors.get(author_id, 'Unknown Author')

            return {
                "id": item.get("id", {}).get("S", ""),
                "title": item.get("course_name", {}).get("S", ""),
                "authorId": author_name,
                "category": item.get("category", {}).get("S", "General"),
                "length": item.get("course_duration", {}).get("N", "0")
            }

        all_items = []
        last_evaluated_key = None

        while True:
            scan_params = {
                'TableName': 'courses'
            }

            if last_evaluated_key:
                scan_params['ExclusiveStartKey'] = last_evaluated_key

            response = dynamodb.scan(**scan_params)
            all_items.extend(response.get('Items', []))
            last_evaluated_key = response.get('LastEvaluatedKey')

            if not last_evaluated_key:
                break

        transformed_items = [transform_body(item) for item in all_items]

        return {
            'statusCode': 200,
            'body': json.dumps(transformed_items),
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