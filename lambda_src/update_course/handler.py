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
        author_id = body.get('author_id')
        category = body.get('category', "General")

        if not course_id or not course_name or not course_duration or not author_id:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Missing required fields'})
            }

        response = dynamodb.get_item(
            TableName='courses',
            Key={'id': {'S': course_id}}
        )

        if 'Item' not in response:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Course not found'})
            }

        dynamodb.update_item(
            TableName='courses',
            Key={'id': {'S': course_id}},
            UpdateExpression='SET course_name = :course_name, course_duration = :course_duration, author_id = :author_id, category = :category',
            ExpressionAttributeValues={
                ':course_name': {'S': course_name},
                ':course_duration': {'N': str(course_duration)},
                ':author_id': {'S': author_id},
                ':category': {'S': category}
            },
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Course updated successfully'})
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

