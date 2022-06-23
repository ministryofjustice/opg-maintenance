data "aws_route53_zone" "maintenance" {
  provider = aws.management_eu_west_1
  name     = "maintenance.opg.service.justice.gov.uk"
}

resource "aws_route53_record" "maintenance" {
  # maintenance.opg.service.justice.gov.uk
  provider = aws.management_eu_west_1
  zone_id  = data.aws_route53_zone.maintenance.zone_id
  name     = "${local.dns_namespace_for_environment}${data.aws_route53_zone.maintenance.name}"
  type     = "A"

  alias {
    evaluate_target_health = false
    name                   = module.eu_west_2.maintenance_lb.dns_name
    zone_id                = module.eu_west_2.maintenance_lb.zone_id
  }

  lifecycle {
    create_before_destroy = true
  }
}
