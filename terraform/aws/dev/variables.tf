variable "aws_region" {
  description = "Região da AWS"
  default     = "us-east-1"
}

variable "lambda_zip_file" {
  description = "Caminho para o .zip da função Lambda"
  default     = "${path.module}/lambda/function.zip"
}
