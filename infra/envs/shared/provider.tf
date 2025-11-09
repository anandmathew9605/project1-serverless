terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      project = "project1-serverless"
      managed = "terraform"
    }
  }
}

