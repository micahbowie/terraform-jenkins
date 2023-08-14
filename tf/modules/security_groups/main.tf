# create security group for ec2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "${var.app}_ec2_security_group"
  description = "enable http access on port 80"
  vpc_id      = var.vpc_id

  ingress {
    description     = "http access port 80"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}_jenkins_security_group"
    Project     = var.project
    Environment = var.environment
    App         = var.app
  }
}

resource "aws_security_group" "alb_security_group" {
  name        = "jenkins_application_load_balancer_security_group"
  description = "enable http access on port 80/443 and ssh access"
  vpc_id      = var.vpc_id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}_application_load_balancer_security_group"
    Project     = var.project
    Environment = var.environment
    App         = var.app
  }
}

