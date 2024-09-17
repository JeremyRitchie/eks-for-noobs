module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "eks-demo"

  cidr = "10.10.0.0/16"

  azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
  elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]

  elasticache_subnet_names = ["eks-demo-pod-us-east-1a", "eks-demo-pod-us-east-1b", "eks-demo-pod-us-east-1c"] // Rename and reuse elasticache subnets for EKS Pods.

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
}