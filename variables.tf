variable "region" {
  type        = string
  description = "AWS region code."
}

variable "access_key" {
  type        = string
  description = "Access key for IAM user."
}

variable "secret_key" {
  type        = string
  description = "Secret access key for IAM user."
}

variable "lambda_function_name" {
  type        = string
  description = "AWS Lambda Function name."
}

variable "glue_service_role_name" {
  type        = string
  description = "AWS Glue Service Role name."
}

variable "log_group_name" {
  type        = string
  description = "CloudWatch Log group name."
}

variable "cw_event_rule_name" {
  type        = string
  description = "CloudWatch EventRule name."
}

variable "glue_db_name" {
  type        = string
  description = "AWS Glue DB name."
}

variable "glue_crawler_name" {
  type        = string
  description = "AWS Glue Crawler name."
}

variable "glue_job_name" {
  type        = string
  description = "AWS Glue Job name."
}

variable "ec2_instance_connection" {
  type = object({
    type     = string
    user     = string
    password = string
    host     = string
  })
  description = "SSH Connection for EC2 instance."
}

variable "kms_alias_name" {
  type        = string
  description = "KMS Alias name."
}

variable "kms_tags" {
  type = object({
    name          = string
    primary_owner = string
    environment   = string
  })
  description = "Tags for KMS Key."
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 Bucket name."
}
