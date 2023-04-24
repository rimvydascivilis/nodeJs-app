resource "aws_ecs_cluster" "main" {
  name = "nodejs-app-cluster"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "nodejs-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn

  container_definitions = jsonencode([{
    name      = var.container_name
    image     = "${aws_ecr_repository.main.repository_url}:${var.image_tag}"
    essential = true
    portMappings = [
      {
        containerPort = 8080
        hostPort      = 8080
        protocol      = "tcp"
      },
    ]
  }])
}

resource "aws_ecs_service" "main" {
  name                = "nodejs-app-service"
  cluster             = aws_ecs_cluster.main.id
  task_definition     = aws_ecs_task_definition.main.arn
  desired_count       = var.ecs_desired_count
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.nodejs-app-alb-tg.arn
    container_name   = var.container_name
    container_port   = 8080
  }
}

resource "aws_security_group" "ecs-sg" {
  name        = "nodejs-app-ecs-sg-task"
  description = "Allow inbound traffic from ALB to ECS"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
