module "eu_west_2" {
  source                                = "./modules/region"
  ingress_allow_list_cidr               = module.allow_list.moj_sites
  ecs_cluster_container_insights        = local.cluster_container_insights
  maintenance_service_capacity_provider = local.ecs_capacity_provider
  maintenance_service_repository_url    = data.aws_ecr_repository.maintenance_app.repository_url
  maintenance_service_container_version = var.container_version
  application_log_retention_days        = local.environment.cloudwatch_log_groups.application_log_retention_days
  account_name                          = local.environment.account_name
  enable_deletion_protection            = local.environment.application_load_balancer.enable_deletion_protection
  providers = {
    aws.region     = aws.eu_west_2
    aws.management = aws.eu_west_2
  }
}

data "aws_ecr_repository" "maintenance_app" {
  name     = "maintenance/maintenance_app"
  provider = aws.management_eu_west_1
}

output "maintenance_url" {
  value = "https://${aws_route53_record.maintenance.fqdn}"
}

module "allow_list" {
  source = "git@github.com:ministryofjustice/terraform-aws-moj-ip-whitelist.git?ref=v1.4.0"
}
