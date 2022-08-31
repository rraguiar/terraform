#
# Route53 Alias
#
resource "aws_route53_record" "www" {
  count = var.route53_create_alias == false ? 0 : 1

  zone_id = var.route53_zone_id
  name    = var.route53_fqdn
  type    = "A"

  alias {
    name                   = var.route53_alias_fqdn
    zone_id                = var.route53_alias_zone_id
    evaluate_target_health = true
  }
}
