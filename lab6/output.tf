
output "bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "S3 bucket name."
}

output "sns_topic_arn" {
  value       = length(aws_sns_topic.this) > 0 ? aws_sns_topic.this[0].arn : null
  description = "SNS topic ARN for bucket notifications."
}

output "policies" {
  value = {
    read       = aws_iam_policy.read.arn
    crud       = aws_iam_policy.crud.arn
    subscribe  = length(var.notify_events) > 0 ? aws_iam_policy.subscribe[0].arn : null
  }
  description = "Map of IAM policy ARNs for the bucket."
}