module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                          = var.cluster_name
  cluster_version                       = var.cluster_version
  cluster_endpoint_private_access       = false
  cluster_endpoint_public_access        = true
  cluster_additional_security_group_ids = [aws_security_group.allow_tls.id]
  authentication_mode                   = "API"

  cluster_addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_POD_ENI                     = "true"
          AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
          AWS_VPC_K8S_CNI_EXTERNALSNAT       = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE  = "standard"
          ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"
          ENABLE_PREFIX_DELEGATION           = "true"
          WARM_PREFIX_TARGET                 = "1"
        }
      })
    }
  }

  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets
  enable_irsa = true

  eks_managed_node_group_defaults = {
    instance_types = var.instance_types
  }

  eks_managed_node_groups = {
    (var.environment) = {
      min_size     = var.cluster_min_size
      max_size     = var.cluster_max_size
      desired_size = var.cluster_desired_size
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            encrypted             = true
            kms_key_id            = aws_kms_key.ebs.arn
            delete_on_termination = true
          }
        }
      }
      launch_template_tags = {
        # enable discovery of autoscaling groups by cluster-autoscaler
        "k8s.io/cluster-autoscaler/enabled" : true,
        "k8s.io/cluster-autoscaler/${var.cluster_name}" : "owned",
      }
    }
  }

  enable_cluster_creator_admin_permissions = true

  access_entries = var.access_entries

  tags = {
    Environment = "${var.environment}"
  }
}

# Create data resource for pod subnets
data "aws_subnet" "pod_subnet" {
  for_each = toset(module.vpc.elasticache_subnets)
  id       = each.value
}

#Create ENIConfig for pods to use different subnets from nodes
resource "kubectl_manifest" "eniconfig" {
  for_each  = data.aws_subnet.pod_subnet
  yaml_body = <<-YAML
  apiVersion: crd.k8s.amazonaws.com/v1alpha1
  kind: ENIConfig
  metadata:
    name: ${each.value.availability_zone}
  spec:
    securityGroups:
      - ${aws_security_group.pod_sg.id}
    subnet: ${each.value.id}
  YAML
}
