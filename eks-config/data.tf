data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "jeremyritchie-terraform-state"
    key    = "eks-for-noobs.tfstate"
    region = "us-east-1"
    assume_role = {
      role_arn = "arn:aws:iam::747340109238:role/terraform-sync"
    }
  }
}