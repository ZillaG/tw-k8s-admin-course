provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 0.12, < 1.3"
  // Comment out the bucket section if you don't want to use online
  // TF states
  backend "s3" {
    bucket = "your_s3_bucket"
    key    = "your_s3_folder"
    region = "us-east-1"
  }
}
