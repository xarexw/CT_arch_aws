""" import json
import boto3

# Створюємо клієнта DynamoDB
dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        all_items = []
        response = dynamodb.scan(
            TableName='authors'
        )
        return {
            'statusCode': 200,
            'body': json.dumps({'authors': all_items})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        } """
        
import json
import boto3

dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
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

        return {
            'statusCode': 200,
            'body': json.dumps({'Items': all_items})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

