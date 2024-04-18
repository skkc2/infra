
# Elastic Load Balancer
resource "aws_lb" "public_lb" {
  name               = "public-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_id

  enable_deletion_protection = false

  security_groups = [aws_security_group.lb_sg.id]

  tags = {
    Name = "Public-LB"
  }
}
resource "aws_lb_target_group" "target_group" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group_attachment" "target_attachment" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.web_server[count.index].id
  port             = 80
  depends_on       = [aws_instance.web_server]
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  depends_on = [aws_lb_target_group_attachment.target_attachment]
}



# EC2 instance
resource "aws_instance" "web_server" {
  count           = var.instance_count
  ami             = var.instance_ami
  instance_type   = var.instance_type
  subnet_id       = var.private_subnet_id[0]
  security_groups = [aws_security_group.instance_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "NginxWebServer"
  }
  depends_on = [aws_lb.public_lb]
}

# RDS Instance
resource "aws_db_instance" "main" {
  allocated_storage    = var.rds_allocated_storage
  storage_type         = var.rds_storage_type
  multi_az             = true
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = var.rds_instance_class
  db_name              = var.rds_db_name
  username             = var.rds_username
  password             = var.rds_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  publicly_accessible  = var.rds_publicly_accessible
  skip_final_snapshot  = true
  tags = {
    Name = "NginxDB"
  }
}

#RDS Subnet Group
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.db_private_subnet_id
}

# Security group for EC2 instances
resource "aws_security_group" "instance_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  tags = {
    Name = "Private-Instance-SG"
  }
}

# Security group for Load Balancer
resource "aws_security_group" "lb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public-LB-SG"
  }
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private-RDS-SG"
  }
}
