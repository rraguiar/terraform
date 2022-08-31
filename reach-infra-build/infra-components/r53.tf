#----- DNS Records --------
resource "aws_route53_record" "admin" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.environment}-admin"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.single.dns_name]
  depends_on = [
    aws_lb.single
  ]
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.environment}-api"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.single.dns_name]
  depends_on = [
    aws_lb.single
  ]
}