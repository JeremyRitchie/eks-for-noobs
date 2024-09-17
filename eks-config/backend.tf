terraform {
  required_version = ">= 1.5.0"
  backend "s3" {
    region         = "us-east-1"
    bucket         = "jeremyritchie-terraform-state"
    key            = "eks-for-noobs-config.tfstate"
    dynamodb_table = "jeremyritchie-terraform-state-lock"
    encrypt        = "true"
    role_arn       = "arn:aws:iam::747340109238:role/terraform-sync"
  }

  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "~>2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
  }
}