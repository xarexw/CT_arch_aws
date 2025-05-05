import json
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        course_id = event.get('pathParameters', {}).get('course-id')
        print(json.dumps(event))
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
                'headers': {
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "Content-Type",
                    "Access-Control-Allow-Methods": "OPTIONS,POST,GET,PUT,DELETE"
                },
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

    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Invalid JSON in request body'})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
