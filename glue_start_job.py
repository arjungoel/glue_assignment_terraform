
import boto3
import json
import os
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_function():

    # Import Boto 3 for AWS Glue
    client = boto3.client('glue')

    # Variables for the job:
    glueJobName = "example"

    # Define Lambda function
    logger.info('## TRIGGERED BY EVENT: ')
    response = client.start_job_run(JobName=glueJobName)
    logger.info('## STARTED GLUE JOB: ' + glueJobName)
    logger.info('## GLUE JOB RUN ID: ' + response['JobRunId'])
    return response


def lambda_handler(event, context):
    logger.info(event['detail'])
    lambda_function()
