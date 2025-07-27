import boto3
import os
import logging
from dotenv import load_dotenv
import re

load_dotenv()

s3_client = boto3.client(
    "s3",
    aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
    region_name=os.getenv("AWS_REGION")
)

BUCKET_NAME = "hospitease"

def upload_file_to_s3(file_obj, filename, folder="test_docs"):
    s3_key = f"{folder}/{filename}"
    logging.info(f"Uploading {filename} to S3 bucket {BUCKET_NAME} at {s3_key}")
    try:
        s3_client.upload_fileobj(file_obj, BUCKET_NAME, s3_key)
        url = f"https://{BUCKET_NAME}.s3.{os.getenv('AWS_REGION')}.amazonaws.com/{s3_key}"
        logging.info(f"Upload successful. File URL: {url}")
        return url
    except Exception as e:
        logging.error(f"Error uploading {filename} to S3: {e}")
        return None
    
def upload_logo_to_s3(file_obj, filename, folder="hospital_logos"):
    if not BUCKET_NAME:
        raise ValueError("S3 BUCKET_NAME is not set. Check your environment variables.")
    s3_key = f"{folder}/{filename}"
    logging.info(f"Uploading {filename} to S3 bucket {BUCKET_NAME} at {s3_key}")
    try:
        s3_client.upload_fileobj(file_obj, BUCKET_NAME, s3_key)
        url = f"https://{BUCKET_NAME}.s3.{os.getenv('AWS_REGION')}.amazonaws.com/{s3_key}"
        logging.info(f"Upload successful. File URL: {url}")
        return url
    except Exception as e:
        logging.error(f"Error uploading {filename} to S3: {e}")
        return None

def get_presigned_url(s3_url, expires_in=3600):
    # Parse bucket and key from s3_url
    match = re.match(r"https://([^\.]+)\.s3[^/]+\.amazonaws\.com/(.+)", s3_url)
    if not match:
        return s3_url  # fallback to original if not S3 URL
    bucket, key = match.groups()
    s3 = boto3.client(
        "s3",
        aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
        aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
        region_name=os.getenv("AWS_REGION"),
    )
    return s3.generate_presigned_url(
        "get_object",
        Params={"Bucket": bucket, "Key": key},
        ExpiresIn=expires_in,
    )