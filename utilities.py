def load_from_s3(bucket, key):
    import boto3
    s3 = boto3.client('s3')
    obj = s3.get_object(Bucket=bucket, Key=key)
    return obj['Body'].read()
