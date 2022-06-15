module "eu_west_2" {
  source                         = "./modules/region"
  network_cidr_block             = "10.162.0.0/16"
  application_log_retention_days = local.account.cloudwatch_log_groups.application_log_retention_days
  application_name               = local.mandatory_moj_tags.application
  account_name                   = local.mandatory_moj_tags.environment-name
  providers = {
    aws.region = aws.eu_west_2
  }

}
