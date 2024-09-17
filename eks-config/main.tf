module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16" #ensure to update this to the latest/desired version

  cluster_name      = data.terraform_remote_state.eks.outputs.eks.cluster_name
  cluster_endpoint  = data.terraform_remote_state.eks.outputs.eks.cluster_endpoint
  cluster_version   = data.terraform_remote_state.eks.outputs.eks.cluster_version
  oidc_provider_arn = data.terraform_remote_state.eks.outputs.eks.oidc_provider_arn

  enable_aws_load_balancer_controller = true
  enable_external_secrets             = true
  enable_cluster_autoscaler           = true
  enable_metrics_server               = true

  aws_load_balancer_controller = {
    set = [
      {
        name  = "vpcId"
        value = data.aws_vpc.cluster_vpc.id
      },
      {
        name  = "podDisruptionBudget.maxUnavailable"
        value = 1
      }
    ]
  }
  tags = {
    Environment = "${var.environment}"
  }
}