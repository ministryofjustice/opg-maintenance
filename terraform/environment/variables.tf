output "workspace_name" {
  value = terraform.workspace
}

variable "container_version" {
  type    = string
  default = "latest"
}

output "container_version" {
  value = var.container_version
}

variable "environments" {
  type = map(
    object({
      account_id    = string
      account_name  = string
      is_production = bool
      ecs = object({
        enable_fargate_spot_capacity_provider = bool
        enable_cluster_container_insights     = bool
      })
      cloudwatch_log_groups = object({
        application_log_retention_days = number
      })
    })
  )
}

locals {
  environment_name = lower(replace(terraform.workspace, "_", "-"))
  environment      = contains(keys(var.environments), local.environment_name) ? var.environments[local.environment_name] : var.environments["default"]

  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg-maintenance"
    environment-name = local.environment_name
    owner            = "OPG Webops: opgteam+maintenance@digital.justice.gov.uk"
    is-production    = local.environment.is_production
    runbook          = "https://github.com/ministryofjustice/opg-maintenance"
    source-code      = "https://github.com/ministryofjustice/opg-maintenance"
  }


  optional_tags = {
    infrastructure-support = "OPG Webops: opgteam+maintenance@digital.justice.gov.uk"
  }

  default_tags = merge(local.mandatory_moj_tags, local.optional_tags)

  ecs_capacity_provider      = local.environment.ecs.enable_fargate_spot_capacity_provider ? "FARGATE_SPOT" : "FARGATE"
  cluster_container_insights = local.environment.ecs.enable_cluster_container_insights ? "enabled" : "disabled"

}
