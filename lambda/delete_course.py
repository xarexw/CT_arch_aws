import json
import boto3
from botocore.exceptions import ClientError
dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        course_id = event.get('course_id', 'default-course-id')

        if not course_id:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Course ID is required'})
            }

        response = dynamodb.get_item(
            TableName='courses',
            Key={
                'id': {'S': course_id}
            }
        )

        if 'Item' in response:
            dynamodb.delete_item(
            TableName='courses',
            Key={
                'id': {'S': course_id}
            }
        )

            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Course deleted successfully'})
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Course not found'})
            }

    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': e.response['Error']['Message']})
        }
