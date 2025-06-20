provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "csv" {
  bucket = var.bucket_name
  acl    = "private"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type    = string
  default = "mini-pipeline-csv"
}
