data "aws_vpc" "cluster_vpc" {
  tags = {
    Name = "market-${var.environment}-vpc"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "ingenio-terraform-state"
    key    = "env:/${var.account_name}/${var.account_name}-eks.tfstate"
    region = "us-east-1"
    assume_role = {
      role_arn = "arn:aws:iam::747340109238:role/terraform-sync"
    }
  }
}