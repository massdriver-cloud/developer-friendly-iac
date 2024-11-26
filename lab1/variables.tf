# Variables
variable "retention_policy" {
  description = "Defines how long objects are retained in the bucket."
  type        = string
  default     = "permanent"
  validation {
    condition     = contains(["ephemeral", "short_term", "archival", "permanent"], var.retention_policy)
    error_message = "Invalid retention policy. Must be one of: ephemeral, short_term, archival, permanent."
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
