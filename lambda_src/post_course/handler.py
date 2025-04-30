import json
import boto3
from botocore.exceptions import ClientError
dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])

        course_id = body.get('course_id')
        course_name = body.get('course_name')
        course_duration = body.get('course_duration')

        if not course_id or not course_name or not course_duration:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Missing required fields'})
            }

        response = dynamodb.get_item(
            TableName='courses',
            Key={
                'id': {'S': course_id}
            }
        )

        if 'Item' in response:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Course ID already exists'})
            }

        dynamodb.put_item(
            TableName='courses',
            Item={
                'id': {'S': course_id},
                'course_name': {'S': course_name},
                'course_duration': {'N': str(course_duration)}
            }
        )

        return {
            'statusCode': 201,
            'body': json.dumps({'message': 'Course created successfully'})
        }

    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': e.response['Error']['Message']})
        }
