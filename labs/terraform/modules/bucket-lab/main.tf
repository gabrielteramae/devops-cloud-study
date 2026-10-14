resource "aws_s3_bucket" "este" {
  bucket        = var.nome_bucket
  force_destroy = true

  tags = {
    Ambiente = var.ambiente
  }
}

resource "aws_s3_bucket_public_access_block" "este" {
  bucket                  = aws_s3_bucket.este.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "este" {
  bucket = aws_s3_bucket.este.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
