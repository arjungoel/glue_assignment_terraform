# IAM Role which is used by the AWS Glue crawler to catalog data for the data lake which will be stored in Amazon S3
resource "aws_iam_role" "glue_service_role" {
  name               = var.glue_service_role_name
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Action": "sts:AssumeRole",
    "Principal": {
        "Service": ["glue.amazonaws.com", "lambda.amazonaws.com", "events.amazonaws.com"]
    },
    "Effect": "Allow",
    "Sid": ""
    }
]
}
EOF
}

resource "aws_iam_policy" "service_role_access_policy" {
  name        = "my-glue-service-role-access-policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
        ]
        Effect = "Allow"
        Resource = ["arn:aws:s3:::csv-to-parquet-glue-transforming-bucket",
        "arn:aws:s3:::csv-to-parquet-glue-transforming-bucket/*"]
      },
      {
        Action = [
          "kms:ListAliases",
          "s3:*",
          "lambda:*",
          "events:*",
          "logs:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "kms:CreateGrant*",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:RevokeGrant",
          "kms:ListGrants"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:kms:us-east-1:*:key/${aws_kms_alias.alias.target_key_id}"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "access_policy" {
  name       = "my-test-glue-service-role-access-policy"
  roles      = [aws_iam_role.glue_service_role.name]
  policy_arn = aws_iam_policy.service_role_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_service_policy" {
  role       = aws_iam_role.glue_service_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
