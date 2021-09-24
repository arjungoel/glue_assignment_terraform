resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = var.glue_db_name
}

# Adding Tables to Glue Database using Crawler and S3 as Target
resource "aws_glue_crawler" "example" {
  database_name = aws_glue_catalog_database.aws_glue_catalog_database.name
  name          = var.glue_crawler_name
  role          = aws_iam_role.glue_service_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.s3_bucket.bucket}/csvfolder/"
  }

  # provisioner "local-exec" {
  #     command = "aws glue start-crawler --name ${self .name}"
  # }
  connection {
    type     = var.ec2_instance_connection.type
    user     = var.ec2_instance_connection.user
    password = var.ec2_instance_connection.password
    host     = var.ec2_instance_connection.host
  }
  provisioner "remote-exec" {
    on_failure = fail
    inline = [
      "aws glue start-crawler --name ${self.name}"
    ]
  }
}


resource "null_resource" "run_crawler" {
  # Changes to the crawler's S3 path requires re-running
  triggers = {
    s3_path = aws_glue_crawler.example.s3_target.0.path
  }

  #   provisioner "local-exec" {
  #     command = "aws glue start-crawler --name ${aws_glue_crawler.example.name}"
  #   }
}

resource "aws_glue_job" "example" {
  name     = var.glue_job_name
  role_arn = aws_iam_role.glue_service_role.arn
  default_arguments = {
    # ... potentially other arguments ...
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.loggroup.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
    "--glue_version"                     = "2.0"
  }

  command {
    script_location = "s3://${aws_s3_bucket.s3_bucket.bucket}/pythonscript/csv_to_parquet_code.py"
  }
}
