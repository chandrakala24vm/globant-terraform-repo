terraform {
  backend "s3" {
    bucket         = "s3-bucket-backend"
    key            = "eks-terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraformstatelock"
    encrypt        = true
  }
}