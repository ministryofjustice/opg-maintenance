resource "aws_lb_target_group" "maintenance" {
  name                 = "${data.aws_default_tags.current.tags.environment-name}-maintenance"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.aws_vpc.main.id
  deregistration_delay = 0

  depends_on = [aws_lb.maintenance]
}

resource "aws_lb" "maintenance" {
  name                       = "${data.aws_default_tags.current.tags.environment-name}-maintenance"
  internal                   = false #tfsec:ignore:AWS005 - public alb
  load_balancer_type         = "application"
  drop_invalid_header_fields = true
  subnets                    = data.aws_subnet.public.*.id
  enable_deletion_protection = var.enable_deletion_protection

  security_groups = [
    aws_security_group.maintenance_loadbalancer.id,
  ]

  # access_logs {
  #   bucket  = data.aws_s3_bucket.access_log.bucket
  #   prefix  = "maintenance-${data.aws_default_tags.current.tags.environment-name}"
  #   enabled = true
  # }
  provider = aws.region
}

resource "aws_lb_listener" "maintenance_loadbalancer_http_redirect" {
  load_balancer_arn = aws_lb.maintenance.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  provider = aws.region
}

data "aws_acm_certificate" "certificate_maintenance" {
  domain   = "${local.certificate_wildcard}maintenance.opg.service.justice.gov.uk"
  provider = aws.region
}


resource "aws_lb_listener" "maintenance_loadbalancer" {
  load_balancer_arn = aws_lb.maintenance.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-2019-08"

  certificate_arn = data.aws_acm_certificate.certificate_maintenance.arn

  default_action {
    target_group_arn = aws_lb_target_group.maintenance.arn
    type             = "forward"
  }
  provider = aws.region
}

resource "aws_lb_listener_certificate" "maintenance_loadbalancer_live_service_certificate" {
  listener_arn    = aws_lb_listener.maintenance_loadbalancer.arn
  certificate_arn = data.aws_acm_certificate.certificate_maintenance.arn
  provider        = aws.region
}

resource "aws_security_group" "maintenance_loadbalancer" {
  name_prefix = "${data.aws_default_tags.current.tags.environment-name}-maintenance-loadbalancer"
  description = "maintenance service application load balancer"
  vpc_id      = data.aws_vpc.main.id
  lifecycle {
    create_before_destroy = true
  }
  provider = aws.region
}

resource "aws_security_group_rule" "maintenance_loadbalancer_port_80_redirect_ingress" {
  description       = "Port 80 ingress for redirection to port 443"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = local.ingress_allow_list_cidr
  security_group_id = aws_security_group.maintenance_loadbalancer.id
}

resource "aws_security_group_rule" "maintenance_loadbalancer_ingress" {
  description       = "Port 443 ingress from the allow list to the application load balancer"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = local.ingress_allow_list_cidr
  security_group_id = aws_security_group.maintenance_loadbalancer.id
  provider          = aws.region
}

resource "aws_security_group_rule" "maintenance_loadbalancer_egress" {
  description       = "Allow any egress from Use service load balancer"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007 - open egress for load balancers
  security_group_id = aws_security_group.maintenance_loadbalancer.id
  provider          = aws.region
}
