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

data "kubectl_path_documents" "application_2048" {
    pattern = "${path.module}/manifests/2048/*.yaml"
}

data "aws_lb" "application_2048" {
  name = "jeremyritchie-demo-eks-alb"
  depends_on = [ time_sleep.wait_for_app ]
}

data "aws_route53_zone" "primary" {
  name = var.domain_name
}
