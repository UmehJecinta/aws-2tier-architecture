# create security group for the web tier 
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "security group for application load balancer"
  vpc_id      = aws_vpc.aws_vpc.id

  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb_sg"
  }
}


resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "security group for webserver instance"
  vpc_id      = aws_vpc.aws_vpc.id

ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }

egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "webserver_sg"
  }
}


# create public application load balancer
resource "aws_lb" "aws_alb" {
  name               = "aws-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  depends_on         = [aws_internet_gateway.aws_igw]
}

# create target group for alb
resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.aws_vpc.id
  
health_check {
  protocol = "HTTP"
  path     = "/"
  port     = "80"
  }

    tags = {
    Name = "alb_tg"
  }
}


# create listener for alb
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.aws_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    
    forward {
      target_group {
        arn = aws_lb_target_group.alb_tg.arn
      }
    }
  }
  tags = {
    Name = "alb_listener"
  }
}


# create security group for the application tier
resource "aws_security_group" "alb_sg2" {
  name        = "alb_sg2"
  description = "security group for application load balancer"
  vpc_id      = aws_vpc.aws_vpc.id

ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb_sg2"
  }
}


resource "aws_security_group" "appserver_sg" {
  name        = "appserver_sg"
  description = "security group for appserver instance"
  vpc_id      = aws_vpc.aws_vpc.id

ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    security_groups = [aws_security_group.alb_sg2.id]
  }

egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "appserver_sg"
  }
}


# create private application load balancer
resource "aws_lb" "aws_alb2" {
  name               = "aws-alb2"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg2.id]
  subnets            = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}

# create target group for alb
resource "aws_lb_target_group" "alb_tg2" {
  name        = "alb-tg2"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.aws_vpc.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = "80"
  }

  tags = {
    Name = "alb_tg2"
  }
}


# create listener for alb
resource "aws_lb_listener" "alb_listener2" {
  load_balancer_arn = aws_lb.aws_alb2.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    
    forward {
      target_group {
        arn = aws_lb_target_group.alb_tg2.arn
      }
    }
  }
  tags = {
    Name = "alb_listener2"
  }
}
