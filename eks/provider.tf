provider "aws" {
  region = "us-east-1"
  assume_role {
    session_name = "eks-for-noobs"
    role_arn     = "arn:aws:iam::747340109238:role/terraform-apply"
  }
}

provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name,
    ]
    command = "aws"
  }
  load_config_file = false
}