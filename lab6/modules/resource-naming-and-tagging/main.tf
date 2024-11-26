variable "project" {
  description = "The project the resource belongs to (e.g., user-service, analytics)."
  type        = string
}

variable "environment" {
  description = "The environment or stage (e.g., prod, qa, staging)."
  type        = string
}

variable "name" {
  description = "A name for this instance of the module (e.g., session-cache, page-cache)."
  type        = string
}

variable "team" {
  description = "The team responsible for the resource (optional)."
  type        = string
  default     = null
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  name_prefix = join("-", [
    var.project,
    var.environment,
    var.name
  ])

  tags = merge(
    {
      Project     = var.project,
      Environment = var.environment,
      Name        = var.name,
      Team        = var.team != null ? var.team : "unassigned"
    }
  )
}

output "name_prefix" {
  description = "A consistent name prefix for resources."
  value       = local.name_prefix
}

output "suffix" {
  description = "A random 4-character suffix to ensure uniqueness."
  value       = random_string.suffix.result
}

output "name" {
  description = "Name prefix + suffix"
  value       = "${local.name_prefix}-${random_string.suffix.result}"
}

output "tags" {
  description = "A standardized map of tags."
  value       = local.tags
}
