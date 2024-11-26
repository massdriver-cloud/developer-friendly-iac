
output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "sns_topic_arn" {
  value       = length(aws_sns_topic.this) > 0 ? aws_sns_topic.this[0].arn : null
  description = "SNS topic ARN for bucket notifications."
}