module "eu_west_2" {
  source                                = "./modules/region"
  maintenance_service_capacity_provider = local.environment.ecs.maintenance_service_capacity_provider
  providers = {
    aws.region = aws.eu_west_2
  }
}
