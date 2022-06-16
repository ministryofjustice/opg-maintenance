module "eu_west_2" {
  source = "./modules/region"
  providers = {
    aws.region = aws.eu_west_2
  }

}
