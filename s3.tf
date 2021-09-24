resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"
  versioning {
    enabled    = false
    mfa_delete = false
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.aws-customer-managed-kms-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block-object-public-access" {
  bucket                  = var.s3_bucket_name
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "csvfolder" {
  bucket   = var.s3_bucket_name
  acl      = "private"
  for_each = fileset("csvfolder/", "*.csv")
  key      = "csvfolder/${each.value}"
  source   = "csvfolder/${each.value}"
  etag     = filemd5("csvfolder/${each.value}")
}

resource "aws_s3_bucket_object" "parquetfolder" {
  bucket   = var.s3_bucket_name
  acl      = "private"
  for_each = fileset("parquetfolder/", "*.parquet")
  key      = "parquetfolder/${each.value}"
  source   = "parquetfolder/${each.value}"
  etag     = filemd5("parquetfolder/${each.value}")
}

resource "aws_s3_bucket_object" "pythonscript" {
  bucket   = var.s3_bucket_name
  acl      = "private"
  for_each = fileset("pythonscript/", "*.py")
  key      = "pythonscript/${each.value}"
  source   = "pythonscript/${each.value}"
  etag     = filemd5("pythonscript/${each.value}")
}
