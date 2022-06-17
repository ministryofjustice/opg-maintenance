data "aws_route53_zone" "maintenance" {
  provider = aws.management
  name     = "maintenance.service.gov.uk"
}

resource "aws_route53_record" "certificate_validation_maintenance" {
  provider = aws.management
  for_each = {
    for dvo in aws_acm_certificate.certificate_maintenance.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.maintenance.zone_id
}

resource "aws_acm_certificate_validation" "certificate_maintenance" {
  certificate_arn         = aws_acm_certificate.certificate_maintenance.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation_maintenance : record.fqdn]
  provider                = aws.region
}

resource "aws_acm_certificate" "certificate_maintenance" {
  domain_name       = "${local.dev_wildcard}maintenance.opg.service.justice.gov.uk"
  validation_method = "DNS"
  provider          = aws.region
}
