data "aws_kms_alias" "cloudwatch_application_logs_encryption" {
  name     = "alias/${data.aws_default_tags.current.tags.application}_cloudwatch_application_logs_encryption_${data.aws_region.current.name}"
  provider = aws.region
}

resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "${data.aws_default_tags.current.tags.environment-name}_application_logs"
  retention_in_days = var.application_log_retention_days
  kms_key_id        = data.aws_kms_alias.cloudwatch_application_logs_encryption.target_key_arn
  provider          = aws.region
}
