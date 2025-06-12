resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
    aws_subnet.public_3.id,
  ]
  tags = { Name = "app-alb" }
}

# Target Groups
resource "aws_lb_target_group" "tg_ubuntu" {
  name     = "tg-ubuntu"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_al2" {
  name     = "tg-al2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_al2023" {
  name     = "tg-al2023"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.tg_al2.arn
        weight = 50
      }
      target_group {
        arn    = aws_lb_target_group.tg_al2023.arn
        weight = 50
      }
    }
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert_validation.certificate_arn

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.tg_al2.arn
        weight = 50
      }
      target_group {
        arn    = aws_lb_target_group.tg_al2023.arn
        weight = 50
      }
    }
  }

  depends_on = [aws_acm_certificate_validation.cert_validation]
}

# Host-based Rules

resource "aws_lb_listener_rule" "rule_ubuntu_http" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_ubuntu.arn
  }

  condition {
    host_header {
      values = ["akifa-ubuntu.codelessops.site"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_al2_http" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_al2.arn
  }

  condition {
    host_header {
      values = ["akifa-al2.codelessops.site"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_al2023_http" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_al2023.arn
  }

  condition {
    host_header {
      values = ["akifa-al2023.codelessops.site"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_ubuntu_https" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_ubuntu.arn
  }

  condition {
    host_header {
      values = ["akifa-ubuntu.codelessops.site"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_al2_https" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_al2.arn
  }

  condition {
    host_header {
      values = ["akifa-al2.codelessops.site"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_al2023_https" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_al2023.arn
  }

  condition {
    host_header {
      values = ["akifa-al2023.codelessops.site"]
    }
  }
}
