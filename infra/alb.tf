resource "aws_lb" "pokedex_alb" {
  name               = "${var.project_name}-alb"
  internal           = false 
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  
  subnets            = aws_subnet.public_subnets[*].id

  tags = {
    Name = "${var.project_name}-ALB"
  }
}

# Target Group 
resource "aws_lb_target_group" "pokedex_tg" {
  name        = "${var.project_name}-tg"
  port        = var.container_port         
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"         

  health_check {
    path                = var.health_check_path 
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = var.health_check_interval
  }
}

#  Listener 
resource "aws_lb_listener" "pokedex_http" {
  load_balancer_arn = aws_lb.pokedex_alb.arn
  port              = var.public_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pokedex_tg.arn
  }
}