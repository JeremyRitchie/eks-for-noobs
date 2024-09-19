environment = "demo"
account_name = "jeremyritchie"
domain_name  = "jeremyritchie.com"

cluster_name    = "jeremyritchie-demo-eks"
cluster_version = "1.30"

instance_types = ["m6a.large"]

cluster_min_size     = 0
cluster_max_size     = 2
cluster_desired_size = 1

access_entries = {
  prod-account = {
    kubernetes_groups = []
    principal_arn     = "arn:aws:iam::747340109238:role/aws-reserved/sso.amazonaws.com/ap-southeast-2/AWSReservedSSO_AWSAdministratorAccess_94f9e4b849a9deaf"

    policy_associations = {
      admin_role = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
}