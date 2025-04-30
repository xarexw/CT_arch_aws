import json
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        def transform_body(item):
            return {
                "id": item.get("id", {}).get("S", "Unknown"),
                "course_name": item.get("course_name", {}).get("S", "No name"),
                "course_duration": item.get("course_duration", {}).get("N", "0")
            }
        
        if 'pathParameters' not in event or 'course-id' not in event['pathParameters']:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Course ID is required'})
            }

        course_id = event['pathParameters'].get('course-id')

        if not course_id:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Course ID is required'})
            }

        response = dynamodb.get_item(
            TableName='courses',
            Key={'id': {'S': course_id}}
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

    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Invalid JSON in request body'})
        }
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': e.response['Error']['Message']})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

