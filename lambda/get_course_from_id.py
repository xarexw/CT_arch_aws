import json
import boto3
from botocore.exceptions import ClientError
dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        def transform_body(item):
            return {
                "id": item["id"]["S"],
                "courseName": item["courseName"]["S"],
                "duration (month)": item["duration"]["N"]
            }
        
        course_id = event.get('course_id', 'default-course-id')

        response = dynamodb.get_item(
            TableName='courses',
            Key={
                'id': {'S': course_id}
            }
        )
        if 'Item' in response:
            item = response['Item']
            transformed_item = transform_body(item)
            pretty_body = json.dumps(transformed_item, indent=4, ensure_ascii=False)

            return {
                'statusCode': 200,
                'body': pretty_body
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Course not found'})
            }

    except ClientError  as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': e.response['Error']['Message']})
        }
