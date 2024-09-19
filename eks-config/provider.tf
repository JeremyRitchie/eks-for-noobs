provider "aws" {
  region = "us-east-1"
  assume_role {
    session_name = "eks-for-noobs-config"
    role_arn     = "arn:aws:iam::747340109238:role/terraform-apply"
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks.cluster_certificate_authority_data)
  host                   = data.terraform_remote_state.eks.outputs.eks.cluster_endpoint
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks.outputs.eks.cluster_name,
    ]
    command = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.eks.outputs.eks.cluster_name,
      ]
      command = "aws"
    }
  }
}

provider "kubectl" {
  host                   = data.terraform_remote_state.eks.outputs.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks.outputs.eks.cluster_name,
    ]
    command = "aws"
  }
  load_config_file = false
}