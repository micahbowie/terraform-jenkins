# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name                       = "${var.environment}-${var.app}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_security_group]
  subnets                    = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  enable_deletion_protection = false

  tags = {
    Name        = "${var.environment}_${var.project_name}_alb"
    Project     = var.project
    Environment = var.environment
    App         = var.app
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.environment}-${var.app}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/login"
    protocol            = "HTTP"
    port                = "8080"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 60
    interval            = 300
    matcher             = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.application_instance_id
  port             = 8080
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# create a listener on port 443 with forward action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}



