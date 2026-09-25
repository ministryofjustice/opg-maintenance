variable "network_cidr_block" {
  type        = string
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
}

locals {
  dev_wildcard = data.aws_default_tags.current.tags.environment-name == "production" ? "" : "*."
}

variable "account" {
  description = "the account object passed into the region module."
  type = object({
    network_firewall = object({
      enabled                  = bool
      allowed_domains          = list(string)
      allowed_prefixed_domains = list(string)
      shared_firewall_configuration = object({
        enabled      = bool
        account_id   = string
        account_name = string
      })
    })
  })
}
