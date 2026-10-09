module "firewalled_network" {
  source                              = "github.com/ministryofjustice/opg-terraform-aws-firewalled-network?ref=v1.3.3"
  cidr                                = var.network_cidr_block
  aws_networkfirewall_firewall_policy = aws_networkfirewall_firewall_policy.main
  default_security_group_ingress      = [{}]
  default_security_group_egress       = [{}]
  enable_dns_hostnames                = true
  enable_dns_support                  = true
  network_firewall_enabled            = var.account.network_firewall.enabled
  shared_firewall_configuration = var.account.network_firewall.shared_firewall_configuration.enabled != true ? null : {
    account_id   = var.account.network_firewall.shared_firewall_configuration.account_id
    account_name = var.account.network_firewall.shared_firewall_configuration.account_name
  }
  providers = {
    aws = aws.region
  }
}


resource "aws_networkfirewall_firewall_policy" "main" {
  name = "opg-maintenance-main"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_engine_options {
      rule_order              = "DEFAULT_ACTION_ORDER"
      stream_exception_policy = "DROP"
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.rule_file.arn
    }
  }
  provider = aws.region
}

resource "aws_networkfirewall_rule_group" "rule_file" {
  capacity = 100
  name     = "opg-maintenance-main-${replace(filebase64sha256("${path.module}/network_firewall_rules.rules.tpl"), "/[^[:alnum:]]/", "")}"
  type     = "STATEFUL"
  rules = templatefile("${path.module}/network_firewall_rules.rules.tpl", {
    allowed_domains          = var.account.network_firewall.allowed_domains
    allowed_prefixed_domains = var.account.network_firewall.allowed_prefixed_domains
    }
  )
  lifecycle {
    create_before_destroy = true
  }
  provider = aws.region
}

data "aws_route_tables" "firewalled_network_application" {
  filter {
    name   = "tag:Name"
    values = ["application-route-table"]
  }
  filter {
    name   = "vpc-id"
    values = [module.firewalled_network.vpc.id]
  }
  provider = aws.region
}

data "aws_caller_identity" "management" {
  provider = aws.management
}

module "vpc_endpoints" {
  source                          = "./modules/vpc_endpoints"
  vpc_id                          = module.firewalled_network.vpc.id
  application_subnets_cidr_blocks = module.firewalled_network.application_subnets[*].cidr_block
  application_subnets_id          = module.firewalled_network.application_subnets[*].id
  public_subnets_cidr_blocks      = module.firewalled_network.public_subnets[*].cidr_block
  application_route_tables        = data.aws_route_tables.firewalled_network_application
  management_account_id           = data.aws_caller_identity.management.account_id
  providers = {
    aws.region = aws.region
  }
}
