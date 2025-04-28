import json
import boto3

dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        def transform_body(item):
            return {
            "id": item["id"]["S"],
            "courseName": item["courseName"]["S"],
            "duration (month)": item["duration (month)"]["N"]
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
                
        pretty_body = json.dumps(transformed_items, indent = 4, ensure_ascii=False)

        return {
            'statusCode': 200,
            'body': pretty_body
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }