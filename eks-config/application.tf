# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create a new ACM certificate for the 2048 application
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "aws_acm_certificate" "application_2048" {
  domain_name       = "2048.${var.domain_name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_2048" {
  for_each = {
    for dvo in aws_acm_certificate.application_2048.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "application_2048" {
  certificate_arn         = aws_acm_certificate.application_2048.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_2048 : record.fqdn]
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Deploy the 2048 application
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "kubectl_manifest" "application_2048" {
    for_each  = toset(data.kubectl_path_documents.application_2048.documents)
    yaml_body = each.value
    depends_on = [ module.eks_blueprints_addons, aws_acm_certificate_validation.application_2048 ]
    lifecycle {
      destroy_before_create = true
    }
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create a DNS record for the 2048 application
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "time_sleep" "wait_for_app" {
  depends_on = [ kubectl_manifest.application_2048 ]
  create_duration = "300s"
}

resource "aws_route53_record" "application_2048" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "2048.jeremyritchie.com"
  type    = "A"

  alias {
    name                   = data.aws_lb.application_2048.dns_name
    zone_id                = data.aws_lb.application_2048.zone_id
    evaluate_target_health = true
  }
}
