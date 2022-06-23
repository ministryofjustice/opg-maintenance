resource "aws_ecs_cluster" "main" {
  name = local.name_prefix
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  provider = aws.region
}

data "aws_iam_policy_document" "task_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
  provider = aws.region
}

resource "aws_iam_role" "execution_role" {
  name               = "${local.name_prefix}-execution-role-ecs-cluster"
  assume_role_policy = data.aws_iam_policy_document.execution_role_assume_policy.json
  provider           = aws.region
}

data "aws_iam_policy_document" "execution_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
  provider = aws.region
}

resource "aws_iam_role_policy" "execution_role" {
  name     = "${local.name_prefix}-execution-role"
  policy   = data.aws_iam_policy_document.execution_role.json
  role     = aws_iam_role.execution_role.id
  provider = aws.region
}

data "aws_iam_policy_document" "execution_role" {
  statement {
    effect = "Allow"
    resources = [
      var.maintenance_service_repository_arn,
      aws_cloudwatch_log_group.application_logs.arn
    ]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
  provider = aws.region
}
