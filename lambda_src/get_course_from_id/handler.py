import json
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.client('dynamodb', region_name='eu-north-1', api_version='2012-08-10')

def lambda_handler(event, context):
    try:
        def transform_body(course_item, author_name):
            return {
                "id": course_item.get("id", {}).get("S", "Unknown"),
                "course_name": course_item.get("course_name", {}).get("S", "No name"),
                "course_duration": course_item.get("course_duration", {}).get("N", "0"),
                "author": author_name,
                "category": course_item.get("category", {}).get("S", "General")
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

        course_response = dynamodb.get_item(
            TableName='courses',
            Key={'id': {'S': course_id}}
        )

        if 'Item' in course_response:
            course_item = course_response['Item']
            author_id = course_item.get('author_id', {}).get('S', None)

            if author_id:
                author_response = dynamodb.get_item(
                    TableName='authors',
                    Key={'id': {'S': author_id}}
                )

                if 'Item' in author_response:
                    author_item = author_response['Item']
                    author_name = (
                        f"{author_item.get('firstName', {}).get('S', '')} "
                        f"{author_item.get('lastName', {}).get('S', '')}"
                    ).strip() or "Unknown Author"
                else:
                    author_name = "Unknown Author"
            else:
                author_name = "Unknown Author"

            transformed_item = transform_body(course_item, author_name)
            pretty_body = json.dumps(transformed_item, indent=4, ensure_ascii=False)

            return {
                'statusCode': 200,
                'headers': {
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "Content-Type",
                    "Access-Control-Allow-Methods": "OPTIONS,POST,GET,PUT,DELETE"
            },
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
