variable "retention_policy" {
  description = "Defines how long objects are retained in the bucket."
  type        = string
  default     = "indefinite"
  validation {
    condition     = contains(["ephemeral", "short_term", "archival", "indefinite"], var.retention_policy)
    error_message = "Invalid retention policy. Must be one of: ephemeral, short_term, archival, indefinite."
  }
}

variable "versioning_policy" {
  description = "Controls versioning and object retention behavior."
  type        = string
  default     = "none"
  validation {
    condition     = contains(["none", "persistent", "audit", "immutable"], var.versioning_policy)
    error_message = "Invalid versioning policy. Must be one of: none, persistent, audit, immutable."
  }
}

variable "region" {
  description = "Region for the S3 bucket."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Name prefix for all resources."
  type        = string
}
