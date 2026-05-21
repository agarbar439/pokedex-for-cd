resource "aws_ecs_cluster" "pokedex_cluster" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled" 
  }
}

resource "aws_ecs_task_definition" "pokedex_task" {
  family                   = var.project_name
  network_mode             = "awsvpc" 
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"    
  memory                   = "512"   
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-app"
      image = "${aws_ecr_repository.ecr_repository.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port 
          hostPort      = var.container_port
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

resource "aws_ecs_service" "pokedex_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.pokedex_cluster.id
  task_definition = aws_ecs_task_definition.pokedex_task.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public_subnets[*].id 
    security_groups  = [aws_security_group.ecs_sg.id]
    
    assign_public_ip = true 
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pokedex_tg.arn
    container_name   = "${var.project_name}-app" 
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.pokedex_http]
}