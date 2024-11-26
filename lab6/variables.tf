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
    condition     = contains(["none", "persistent", "audit"], var.versioning_policy)
    error_message = "Invalid versioning policy. Must be one of: none, persistent, audit."
  }
}

variable "region" {
  description = "Region for the S3 bucket."
  type        = string
  default     = "us-east-1"
}

variable "notify_events" {
  description = "A list of S3 events to notify on (e.g., s3:ObjectCreated:*, s3:ObjectRemoved:*). Leave empty for no notifications."
  type        = list(string)
  default     = []
}

variable "metadata" {
  description = "Metadata about the resource including project, environment, name and team"
  type = object({
    project     = string
    environment = string
    name        = string
    team        = optional(string)
  })
}