output "nome_bucket" {
  value = aws_s3_bucket.lab.bucket
}

output "bucket_extra_arn" {
  value = module.bucket_extra.arn
}
