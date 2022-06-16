resource "aws_ecs_service" "maintenance" {
  name                  = data.aws_default_tags.current.tags.application
  cluster               = aws_ecs_cluster.main.id
  desired_count         = 1
  platform_version      = "1.4.0"
  wait_for_steady_state = true

  capacity_provider_strategy {
    capacity_provider = var.maintenance_service_capacity_provider
    weight            = 100
  }

  lifecycle {
    create_before_destroy = true
  }
  provider = aws.region
}


resource "aws_ecs_task_definition" "maintenance" {
  family                   = local.name_prefix
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions    = "[${local.maintenance_app}]"
  task_role_arn            = aws_iam_role.admin_task_role.arn
  execution_role_arn       = aws_iam_role.execution_role.arn
  provider                 = aws.region
}

resource "aws_iam_role" "admin_task_role" {
  name               = "${local.name_prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_role_assume_policy.json
  provider           = aws.region
}

locals {
  maintenance_app = jsonencode(
    {
      cpu         = 1,
      essential   = true,
      image       = "${var.maintenance_service_repository_url}:${var.maintenance_service_container_version}",
      mountPoints = [],
      name        = "app",
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
        }
      ],
      volumesFrom = [],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.application_logs.name,
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = data.aws_default_tags.current.tags.environment-name
        }
      },
      environment = [
        {
          name  = "LOGGING_LEVEL",
          value = tostring(100)
        },
        {
          name  = "MAINTENANCE_PORT",
          value = tostring(80)
        }
      ]
    }
  )

}
