locals {
  retention_policies = {
    ephemeral  = { expiration_days = 7, transition_days = null, storage_class = null }
    short_term = { expiration_days = 30, transition_days = null, storage_class = null }
    archival   = { expiration_days = null, transition_days = 1, storage_class = "GLACIER" }
    indefinite = { expiration_days = null, transition_days = null, storage_class = null }
  }

  versioning_policies = {
    none       = { enabled = false, retention_days = null }
    persistent = { enabled = true, retention_days = null }
    audit      = { enabled = true, retention_days = 365 }
  }

  enable_notifications = length(var.notify_events) > 0 ? 1 : 0
  lifecycle_rules      = local.retention_policies[var.retention_policy]
  versioning_rules     = local.versioning_policies[var.versioning_policy]
}

module "metadata" {
  source      = "./modules/resource-naming-and-tagging"
  project     = var.metadata.project
  environment = var.metadata.environment
  name        = var.metadata.name
  team        = var.metadata.team
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = module.metadata.name
  force_destroy = false
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = local.versioning_rules.enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "object-expiration"
    status = local.lifecycle_rules.expiration_days != null ? "Enabled" : "Disabled"

    expiration {
      days = local.lifecycle_rules.expiration_days
    }
  }

  dynamic "rule" {
    for_each = local.lifecycle_rules.transition_days != null && local.lifecycle_rules.storage_class != null ? [local.lifecycle_rules] : []

    content {
      id     = "object-transition"
      status = "Enabled"

      transition {
        days          = rule.value.transition_days
        storage_class = rule.value.storage_class
      }
    }
  }
}

resource "aws_sns_topic" "this" {
  count = local.enable_notifications
  name  = "${aws_s3_bucket.this.bucket}-notifications"
}

resource "aws_s3_bucket_notification" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "topic" {
    for_each = length(var.notify_events) > 0 ? [aws_sns_topic.this[0].arn] : []
    content {
      topic_arn = topic.value
      events    = var.notify_events
    }
  }
}

resource "aws_sns_topic_policy" "this" {
  count = local.enable_notifications

  arn = aws_sns_topic.this[0].arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action   = "SNS:Publish",
        Resource = aws_sns_topic.this[0].arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn" : aws_s3_bucket.this.arn
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "read" {
  name        = "${module.metadata.name}-read-policy"
  description = "IAM policy for read-only access to the bucket."
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "crud" {
  name        = "${module.metadata.name}-crud-policy"
  description = "IAM policy for full CRUD access to the bucket."
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "subscribe" {
  count       = length(var.notify_events) > 0 ? 1 : 0
  name        = "${module.metadata.name}-subscribe-policy"
  description = "IAM policy for subscribing to bucket events."
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = aws_sns_topic.this[0].arn
      }
    ]
  })
}
