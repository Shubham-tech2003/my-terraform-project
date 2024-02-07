terraform {
  # Specify the source for the Terraform configuration
  source = "../"
}

# Input variables specific to the environment
inputs = {
  enable_s3_buckets = true
  enable_sqs_queues = true

  # Define environment-specific names for S3 buckets and SQS queues
  s3_bucket_names = ["prod-shubham-og"]
  sqs_queue_names = ["prod-shubham-ue"]
}
