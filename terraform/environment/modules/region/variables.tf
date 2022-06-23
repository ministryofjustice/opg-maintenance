locals {
  name_prefix                   = "${data.aws_default_tags.current.tags.application}-${data.aws_default_tags.current.tags.environment-name}-${data.aws_region.current.name}"
  dns_namespace_for_environment = var.account_name == "production" ? "" : "${data.aws_default_tags.current.tags.environment-name}."
  certificate_wildcard          = var.account_name == "production" ? "" : "*."
}

variable "maintenance_service_capacity_provider" {
  type        = string
  description = "Name of the capacity provider to use. Valid values are FARGATE_SPOT and FARGATE"
}

variable "ingress_allow_list_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDR ranges permitted to access the service"
}

variable "maintenance_service_container_version" {
  type        = string
  description = "Tag of the maintenance app container to deploy"
}

variable "maintenance_service_repository_url" {
  type        = string
  description = "ECR repository url for the maintenance app container"
}

variable "maintenance_service_repository_arn" {
  type        = string
  description = "ECR repository arn for the maintenance app container"
}

variable "application_log_retention_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
}

variable "account_name" {
  type        = string
  description = "Name of the target account for deployments"
}

variable "enable_deletion_protection" {
  type        = bool
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
}
