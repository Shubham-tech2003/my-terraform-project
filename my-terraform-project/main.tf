# my-terraform-project/main.tf
terraform {
  required_providers {
    aws = {
      version = "~> 5.35"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region      = "ap-southeast-1"
  max_retries = 5 
}

variable "enable_s3_buckets" {
  type    = bool
  default = true
}

variable "enable_sqs_queues" {
  type    = bool
  default = true
}

variable "s3_bucket_names" {
  type    = list(string)
  default = []
}

variable "sqs_queue_names" {
  type    = list(string)
  default = []
}

resource "aws_s3_bucket" "s3_buckets" {
  for_each = var.enable_s3_buckets ? { for name in var.s3_bucket_names : name => "${terraform.workspace}-${name}" } : {}

  bucket = each.key
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse_configuration" {
  for_each = aws_s3_bucket.s3_buckets

  bucket = each.key

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  for_each = aws_s3_bucket.s3_buckets

  bucket = each.key

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_cors_configuration" "cors_configuration" {
  for_each = aws_s3_bucket.s3_buckets

  bucket = each.key

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["x-amz-server-side-encryption"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["HEAD", "GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
  }
}

resource "aws_sqs_queue" "sqs_queues" {
  for_each = { for name in var.sqs_queue_names : "${terraform.workspace}-${name}" => name }

  name                      = each.key
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  visibility_timeout_seconds = 30
}
