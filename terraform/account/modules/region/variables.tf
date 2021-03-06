variable "network_cidr_block" {
  type        = string
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
}

locals {
  dev_wildcard = data.aws_default_tags.current.tags.environment-name == "production" ? "" : "*."
}
