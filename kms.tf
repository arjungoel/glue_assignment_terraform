resource "aws_kms_key" "aws-customer-managed-kms-key" {
  description             = "Customer Managed KMS key (CMK)."
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.kms_tags
}

resource "aws_kms_alias" "alias" {
  name          = var.kms_alias_name
  target_key_id = aws_kms_key.aws-customer-managed-kms-key.key_id
}
