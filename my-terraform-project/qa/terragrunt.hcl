inputs = {
  enable_s3_buckets = true
  enable_sqs_queues = true

  # Define environment-specific names for S3 buckets and SQS queues
  s3_bucket_names = ["qa-shubham-pc"]
  sqs_queue_names = ["qa-shubham-qu"]
}

terraform {
  # Specify the source for the Terraform configuration
  source = "../"
}
