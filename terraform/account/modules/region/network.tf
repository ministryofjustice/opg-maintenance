module "network" {
  source                         = "git@github.com:ministryofjustice/opg-terraform-aws-network.git?ref=v1.0.0"
  cidr                           = "10.162.0.0/16"
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]
  providers = {
    aws = aws.region
  }
}
