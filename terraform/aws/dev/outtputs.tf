output "lambda_name" {
  value = aws_lambda_function.processor.function_name
}

output "bucket_name" {
  value = aws_s3_bucket.input.bucket
}
