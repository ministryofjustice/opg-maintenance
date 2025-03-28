module "network" {
  source                         = "github.com/ministryofjustice/opg-terraform-aws-network?ref=v1.4.0"
  cidr                           = var.network_cidr_block
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]
  providers = {
    aws = aws.region
  }
}
