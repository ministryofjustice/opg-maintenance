output "workspace_name" {
  value = terraform.workspace
}

variable "accounts" {
  type = map(
    object({
      account_id    = string
      account_name  = string
      is_production = bool
      cloudwatch_log_groups = object({
        application_log_retention_days = number
      })
    })
  )
}

locals {
  account_name = lower(replace(terraform.workspace, "_", "-"))
  account      = contains(keys(var.accounts), local.account_name) ? var.accounts[local.account_name] : var.accounts["default"]

  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg-maintenance"
    environment-name = local.account_name
    owner            = "OPG Webops: opgteam+maintenance@digital.justice.gov.uk"
    is-production    = local.account.is_production
    runbook          = "https://github.com/ministryofjustice/opg-maintenance"
    source-code      = "https://github.com/ministryofjustice/opg-maintenance"
  }


  optional_tags = {
    infrastructure-support = "OPG Webops: opgteam+maintenance@digital.justice.gov.uk"
  }

  default_tags = merge(local.mandatory_moj_tags, local.optional_tags)
}
