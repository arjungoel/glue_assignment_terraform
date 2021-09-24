resource "aws_lambda_function" "glue_start_job" {
  filename      = "./glue_start_job.zip"
  function_name = var.lambda_function_name
  runtime       = "python3.8"
  role          = aws_iam_role.glue_service_role.arn
  handler       = "glue_start_job.lambda_handler"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_glue_start_job" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.glue_start_job.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_two_minutes.arn
}
