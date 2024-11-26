variable "region" {
  description = "The region of the bucket."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the bucket."
  type        = string
}

variable "force_destroy" {
  description = "Whether to allow bucket deletion even if it contains objects."
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Block public ACLs for the bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs for the bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public buckets."
  type        = bool
  default     = true
}

variable "versioning_status" {
  description = "Versioning status: 'Enabled' or 'Suspended'."
  type        = string
  default     = "Suspended"
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the bucket."
  type = list(object({
    id         = string
    status     = string
    expiration = optional(object({
      days = number
    }))
    transition = optional(object({
      days          = number
      storage_class = string
    }))
  }))
  default = []
}