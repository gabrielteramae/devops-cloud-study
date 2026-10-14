provider "aws" {
  region = var.regiao
}

provider "aws" {
  alias  = "billing"
  region = "us-east-1"
}

resource "random_id" "sufixo" {
  byte_length = 4
}

resource "aws_s3_bucket" "lab" {
  bucket        = "lab-terraform-${random_id.sufixo.hex}"
  force_destroy = true

  tags = {
    Ambiente = var.ambiente
  }
}

resource "aws_s3_bucket_public_access_block" "lab" {
  bucket                  = aws_s3_bucket.lab.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lab" {
  bucket = aws_s3_bucket.lab.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

module "bucket_extra" {
  source      = "./modules/bucket-lab"
  nome_bucket = "lab-terraform-modulo-${random_id.sufixo.hex}"
  ambiente    = var.ambiente
}

resource "aws_budgets_budget" "lab" {
  count    = var.alerta_email == "" ? 0 : 1
  provider = aws.billing

  name         = "lab-devops-mensal"
  budget_type  = "COST"
  limit_amount = "5"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alerta_email]
  }
}
