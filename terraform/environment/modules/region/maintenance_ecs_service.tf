resource "aws_ecs_service" "maintenance" {
  name                  = "maintenance-service"
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
