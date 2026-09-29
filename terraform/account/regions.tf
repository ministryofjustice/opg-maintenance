module "eu_west_2" {
  source             = "./modules/region"
  account            = local.account
  network_cidr_block = "10.150.0.0/16"
  providers = {
    aws.region     = aws.eu_west_2
    aws.management = aws.management_eu_west_2
  }

}
