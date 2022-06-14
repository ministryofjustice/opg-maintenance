module "network" {
  source                         = "git@github.com:ministryofjustice/opg-terraform-aws-network.git?ref=v0.2.0-UML-2475.5"
  cidr                           = "10.162.0.0/16"
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]
  providers = {
    aws = aws.region
  }
}
