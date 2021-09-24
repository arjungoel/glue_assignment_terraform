This README is for transforming the data from csv format to parquet format using Glue.

**AWS Services Used**:
- s3, kms, iam, glue (database, tables, crawlers, jobs), lambda, cloudwatch rule

In order to set up the workflow, you need to have following:

1. An AWS Account (Free Tier or Enterprise)
2. Terraform Installed in your machine
3. create the s3 bucket. Encrypt it with either AWS managed kms key or Customer managed kms key.
4. There are three folders inside s3 bucket, one for csv files, another for storing generated parquet files and one folder for glue ETL script.
5. create a glue service role. Make sure it should have trust relationship with `glue.amazonaws.com` endpoint. Also it should have the Glue access and S3 bucket access.
6. create the glue database.
7. add the tables using crawlers to the db with target for s3 source
8. view the schema.
9. create glue job to transform csv files into parquet and stored in destination s3 bucket location.
10. Written a lambda function to run the glue job after every `x` minutes.
11. The lambda is meant to be run on scheduled basis using a CloudWatch event rule.

NOTE:

make sure to have some things:
- Installation of `pyspark` in local machine in case you're writing ETL code in local machine. Run `pip install pyspark` to install it.
- AWS Glue version should be either 2.0 or 3.0
- Terraform version 0.14.x or above. 
- Make sure to use `access_key` and `secret_access_key` for provider configuration.
- If you are working in collaborative environment try to maintain your `terraform.tfstate` file either in S3 bucket or DynamoDB Table (Remote and Backends concept TF). For more information refer the link: https://www.terraform.io/docs/language/settings/backends/remote.html
- Try to replace resources name with your ones.
- Include files like `terraform.tfstate` and `terraform.tfvars` in .gitignore file as these contains the sensitive and configuration data.

**AWS Charges**:
* `Crawler` works on pay-as-you-model so it will only charge for the amount of time it is running.
* If your schema has partitions then only you need to trigger the crawler with updated changes else no need. for more information refer this link: https://docs.aws.amazon.com/glue/latest/dg/crawler-s3-folder-table-partition.html
* For glue job billing, refer the documentation: https://docs.aws.amazon.com/glue/latest/dg/add-job.html


