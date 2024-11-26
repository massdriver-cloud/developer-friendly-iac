provider "aws" {
  region = var.region
  default_tags {
    tags = module.metadata.tags
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.77"
    }
  }
}