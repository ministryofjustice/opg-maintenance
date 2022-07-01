resource "aws_kms_key" "cloudwatch" {
  description             = "${data.aws_default_tags.current.tags.application} cloudwatch application logs encryption key for ${data.aws_region.current.name}"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_default_tags.current.tags.environment-name == "development" ? data.aws_iam_policy_document.cloudwatch_kms_merged.json : data.aws_iam_policy_document.cloudwatch_kms.json
  provider                = aws.region
}

resource "aws_kms_alias" "cloudwatch_alias" {
  name          = "alias/${data.aws_default_tags.current.tags.application}_cloudwatch_application_logs_encryption_${data.aws_region.current.name}"
  target_key_id = aws_kms_key.cloudwatch.key_id
  provider      = aws.region

}

# See the following link for further information
# https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
data "aws_iam_policy_document" "cloudwatch_kms_merged" {
  provider = aws.region
  source_policy_documents = [
    data.aws_iam_policy_document.cloudwatch_kms.json,
    data.aws_iam_policy_document.cloudwatch_kms_dev_operator_admin.json
  ]
}

data "aws_iam_policy_document" "cloudwatch_kms" {
  provider = aws.region
  statement {
    sid       = "Allow Key to be used for Encryption"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    principals {
      type = "Service"
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com",
        "events.amazonaws.com"
      ]
    }
  }

  statement {
    sid       = "Key Administrator"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/breakglass",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/opg-maintenance-ci",
      ]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_kms_dev_operator_admin" {
  provider = aws.region
  statement {
    sid       = "Dev Account Key Administrator"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/operator"
      ]
    }
  }
}
