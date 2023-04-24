resource "aws_alb" "nodejs-app-alb" {
  name            = "nodejs-app-alb"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb-sg.id]
  subnets         = aws_subnet.public.*.id
  enable_deletion_protection = false

  tags = {
    Name = "nodejs-app-alb"
  }
}

resource "aws_alb_target_group" "nodejs-app-alb-tg" {
  name     = "nodejs-app-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = var.health_check_path
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.nodejs-app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.nodejs-app-alb-tg.arn
    type             = "forward"
  }  
}

resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow inbound traffic from ALB to ECS"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
}
