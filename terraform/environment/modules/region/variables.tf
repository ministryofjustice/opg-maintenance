locals {
  name_prefix = "${data.aws_default_tags.current.tags.application}-${data.aws_default_tags.current.tags.environment-name}-${data.aws_region.current.name}"
}

variable "maintenance_service_capacity_provider" {
  type        = string
  description = "Name of the capacity provider to use. Valid values are FARGATE_SPOT and FARGATE"
}

variable "ecs_cluster_container_insights" {
  type        = string
  description = "value for containerInsights setting on ecs cluster. Valid values are enabled and disabled"
}

variable "maintenance_service_container_version" {
  type        = string
  description = "Tag of the maintenance app container to deploy"
}

variable "maintenance_service_repository_url" {
  type        = string
  description = "ECR repository url for the maintenance app container"
}

variable "application_log_retention_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
}
