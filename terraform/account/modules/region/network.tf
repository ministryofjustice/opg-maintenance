module "network" {
  source                         = "github.com/ministryofjustice/opg-terraform-aws-network?ref=v1.7.1"
  cidr                           = "10.162.0.0/16"
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]
  providers = {
    aws = aws.region
  }
}

module "firewalled_network" {
  source                              = "github.com/ministryofjustice/opg-terraform-aws-firewalled-network?ref=v1.3.2"
  cidr                                = var.network_cidr_block
  aws_networkfirewall_firewall_policy = aws_networkfirewall_firewall_policy.main
  network_firewall_enabled            = false
  default_security_group_ingress      = [{}]
  default_security_group_egress       = [{}]
  providers = {
    aws = aws.region
  }
}


resource "aws_networkfirewall_firewall_policy" "main" {
  name = "main"

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
}

resource "aws_networkfirewall_rule_group" "rule_file" {
  capacity = 100
  name     = "main-${replace(filebase64sha256("${path.module}/network_firewall_rules.rules.tpl"), "/[^[:alnum:]]/", "")}"
  type     = "STATEFUL"
  rules = templatefile("${path.module}/network_firewall_rules.rules.tpl", {
    allowed_domains          = var.account.network_firewall.allowed_domains
    allowed_prefixed_domains = var.account.network_firewall.allowed_prefixed_domains
    }
  )
  lifecycle {
    create_before_destroy = true
  }
}
