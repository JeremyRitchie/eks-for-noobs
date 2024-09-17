variable "environment" {
  type        = string
  description = "Environment: dev | stage | prod"
}

variable "account_name" {
  type        = string
  description = "AWS account name"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_version" {
  type        = string
  description = "EKS version"
}

variable "instance_types" {
  type        = list(string)
  description = "EC2 instance types for EKS nodes"
}

variable "cluster_min_size" {
  type        = number
  description = "Minimum number of EKS nodes"
}

variable "cluster_max_size" {
  type        = number
  description = "Maximum number of EKS nodes"
}

variable "cluster_desired_size" {
  type        = number
  description = "Desired number of EKS nodes"
}

variable "access_entries" {
  type = map(object({
    kubernetes_groups = list(string)
    principal_arn     = string
    policy_associations = map(object({
      policy_arn = string
      access_scope = object({
        type = string
      })
    }))
  }))
}