terraform {
  backend "s3" {
    bucket         = "your-unique-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"  # Optional, for state locking
    encrypt        = true
  }
}