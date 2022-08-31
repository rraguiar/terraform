# Create a single Application Load Balancer with two listeners (port 80 and 443), where the listener #
# policies are:                                                                                      #
# 1) port 80 redirects to port 443 to force TLS/SSL termination on Load Balancer level               #
# 2) URL staging-apple-c2c-api.applebyengage.com is redirecting to a espcific target group                         #
# 3) URL staging-apple-c2c-admin.applebyengage.com is redirecting to a espcific target group                       #
# 4) * redirecting to the default target group                                                       #
# Having one load balancer reduces the infrastructure costs                                          #
resource "aws_lb" "single" {
  name                       = "${var.environment}-${var.customer}-${var.application_name}-lb" #Limit of 32 characters
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  subnets                    = [var.public_subnet_id[0], var.public_subnet_id[1]]
  security_groups            = [aws_security_group.alb.id]
  tags = merge(
    local.common_tags,
    tomap({
      "Name" =  "${var.environment}-${var.customer}-${var.application_name}-lb"
      "service_role" = "alb"
      "application_name" = var.application_name
    })
  )
}

# Create Podium Admin Load Balancer Listener ####################################################################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.single.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.single.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.issued.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.single.arn
  }
}


resource "aws_lb_listener_rule" "https_api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.single.arn
  }

  condition {
    host_header {
      values = ["${var.environment}-api.${var.r53_domain}"]
#      values = ["${var.environment}-${var.customer}-c2c-api.${var.r53_domain}"]
    }
  }
}

resource "aws_lb_listener_rule" "https_admin" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.single.arn
  }

  condition {
    host_header {
      values = ["${var.environment}-admin.${var.r53_domain}"]
    }
  }
}

resource "aws_lb_target_group" "single" {
  name        = "${var.environment}-${var.customer}-${var.application_name}-lb-tg" #Limit of 32 characters
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-lb-tg"
      "service_role" = "tg"
      "application_name" = var.application_name
    })
  )
}

