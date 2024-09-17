# the following resources are for allowing access to a private endpoint
# https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html#private-access
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic from VPC"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = module.vpc.vpc_cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_pod_subnets" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = module.vpc.vpc_cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_pods" {
  security_group_id = aws_security_group.allow_tls.id
  referenced_security_group_id = aws_security_group.pod_sg.id
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "node_egress" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Security group pods will use in the custom ENI config
resource "aws_security_group" "pod_sg" {
  name        = "pod_sg"
  description = "Security group for pods on EKS"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "pod_ingress" {
  security_group_id = aws_security_group.pod_sg.id
  cidr_ipv4         = module.vpc.vpc_cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "pod_service_range_ingress" {
  security_group_id = aws_security_group.pod_sg.id
  cidr_ipv4         = "172.20.0.0/16"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_nodes" {
  security_group_id = aws_security_group.pod_sg.id
  referenced_security_group_id = aws_security_group.allow_tls.id
  ip_protocol       = "-1"
  description       = "Allow internal traffic from node to pod"
}

resource "aws_vpc_security_group_egress_rule" "pod_egress" {
  security_group_id = aws_security_group.pod_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_internal_traffic" {
  security_group_id = module.eks.node_security_group_id
  cidr_ipv4         = module.vpc.vpc_cidr_block
  ip_protocol       = "-1"
  description       = "Allow internal traffic between nodes"
}