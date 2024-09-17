provider "aws" {
  region = "us-east-1"
  assume_role {
    session_name = "terraform-market-prod-apply"
    role_arn     = "arn:aws:iam::227902574431:role/terraform-apply"
  }

  default_tags {
    tags = {
      map-migrated = "migPWOAZYXJ5K"
    }
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