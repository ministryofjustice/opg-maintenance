data "aws_route53_zone" "maintenance" {
  provider = aws.management
  name     = "maintenance.opg.service.justice.gov.uk"
}

resource "aws_route53_record" "maintenance" {
  # maintenance.opg.service.justice.gov.uk
  provider = aws.management
  zone_id  = data.aws_route53_zone.maintenance.zone_id
  name     = "${local.dns_namespace_for_environment}${data.aws_route53_zone.maintenance.name}"
  type     = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_lb.maintenance.dns_name
    zone_id                = aws_lb.maintenance.zone_id
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "public_facing_view_domain" {
  value = "https://${aws_route53_record.maintenance.fqdn}"
}
