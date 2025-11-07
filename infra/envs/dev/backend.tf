terraform {
  backend "s3" {
    bucket         = "project1-serverless-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "project1-serverless-tf-locks"
    encrypt        = true
  }
}
