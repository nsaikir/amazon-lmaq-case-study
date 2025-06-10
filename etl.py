# Sample data extraction script
import pandas as pd
import boto3
import os

s3 = boto3.client('s3')
obj = s3.get_object(Bucket='lmaq-sample', Key='navigation.csv')
df = pd.read_csv(obj['Body'])
df.dropna().to_csv("data/cleaned_navigation.csv", index=False)
