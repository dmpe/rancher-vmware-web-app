import boto3

# Idea: upload datat to s3 instead, as well as git
# each trigger causes to 

s3_client = boto3.client(
    service_name='s3',
    endpoint_url='https://bucket.vpce-abc123-abcdefgh.s3.us-east-1.vpce.amazonaws.com', 

)
