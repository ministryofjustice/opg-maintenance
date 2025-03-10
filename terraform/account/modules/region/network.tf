module "network" {
  source                         = "github.com/ministryofjustice/opg-terraform-aws-network?ref=v1.5.2"
  cidr                           = var.network_cidr_block
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]
  providers = {
    aws = aws.region
  }
}
