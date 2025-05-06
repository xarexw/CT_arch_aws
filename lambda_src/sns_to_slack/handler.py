import json
import urllib3
import boto3

def lambda_handler(event, context):
    print("Event: ", json.dumps(event))
    webhook_url = 'https://hooks.slack.com/services/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'

    http = urllib3.PoolManager()
    
    slack_data = {
        'text': "Hello Test"
    }
    
    response = http.request(
        'POST',
        webhook_url,
        body=json.dumps(slack_data),
        headers={'Content-Type': 'application/json'}
    )
    
    print("Slack response: ", response.status)

    cloudwatch = boto3.client('cloudwatch')
    cloudwatch.put_metric_data(
        Namespace='MyAppMetrics',  
        MetricData=[
            {
                'MetricName': 'MyCustomMetric', 
                'Value': 1,                      
                'Unit': 'Count'                  
            },
        ]
    )
    print("Custom metric sent!")

    return {'statusCode': response.status}