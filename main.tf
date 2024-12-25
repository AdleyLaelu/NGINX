provider "aws" {
  region = var.aws_region
}

# Create ECS Cluster
resource "aws_ecs_cluster" "nginx_cluster" {
  name = var.cluster_name
}

# Create ECS Task Role (IAM Role for ECS Task)
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role-unique"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

# Create ECS Execution Role (IAM Role for ECS Task execution)
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role-unique"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

# Create ECS Task Definition
resource "aws_ecs_task_definition" "nginx_task" {
  family                = var.task_definition_name
  execution_role_arn    = aws_iam_role.ecs_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([{
    name      = "nginx-container"
    image     = "nginx:latest"
    essential = true
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
  }])
}

# Create Load Balancer (ALB)
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
}

# Create Target Group for ALB
resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginx-target-group-unique"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Create Listener for the ALB (ALB will forward HTTP traffic to the target group)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

# Create ECS Service
resource "aws_ecs_service" "nginx_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
    container_name   = "nginx-container"
    container_port   = 80
  }
}

# IAM policy for ECS Task execution role
resource "aws_iam_policy" "ecs_execution_policy" {
  name        = "ecs-execution-policy"
  description = "Allow ECS tasks to pull images from ECR and write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
        Effect   = "Allow"
      },
      {
        Action   = "ecr:BatchGetImage"
        Resource = "*"
        Effect   = "Allow"
      },
      {
        Action   = "ecr:BatchCheckLayerAvailability"
        Resource = "*"
        Effect   = "Allow"
      },
      {
        Action   = "logs:CreateLogStream"
        Resource = "*"
        Effect   = "Allow"
      },
      {
        Action   = "logs:PutLogEvents"
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
}

# Attach policy to ECS execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
  role       = aws_iam_role.ecs_execution_role.name
}
