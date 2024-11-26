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

  lifecycle_rules = local.retention_policies[var.retention_policy]
  versioning_rules = local.versioning_policies[var.versioning_policy]
}

resource "aws_s3_bucket" "this" {
  bucket_prefix  = var.name_prefix
  force_destroy  = false
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
