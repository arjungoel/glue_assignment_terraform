resource "aws_cloudwatch_log_group" "loggroup" {
  name = var.log_group_name
}
resource "aws_cloudwatch_event_rule" "every_two_minutes" {
  name                = var.cw_event_rule_name
  description         = "Fires every two minutes"
  schedule_expression = "rate(2 minutes)"
}

resource "aws_cloudwatch_event_target" "every_two_minutes" {
  target_id = "glue-job-start"
  arn       = aws_lambda_function.glue_start_job.arn
  rule      = aws_cloudwatch_event_rule.every_two_minutes.name
}
