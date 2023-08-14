data "aws_launch_template" "jenkins_template" {
  name = "jenkins-template"
}

resource "aws_instance" "jenkins_web" {
  launch_template {
    id      = data.aws_launch_template.jenkins_template.id
    version = data.aws_launch_template.jenkins_template.latest_version
  }
  subnet_id                   = var.public_subnet_az1_id
  vpc_security_group_ids      = [var.ec2_security_group_id]
  associate_public_ip_address = true
  key_name                    = var.e2_instance_key_name

  tags = {
    Name        = "${var.environment}_jenkins"
    Project     = var.project
    Environment = var.environment
    App         = var.app
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = aws_instance.jenkins_web.id
}

resource "aws_ebs_volume" "this" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  size              = 140
  iops              = 3000
  type              = "gp3"
  throughput        = 125

  tags = {
    Name        = "${var.environment}_jenkins"
    Project     = var.project
    Environment = var.environment
    App         = var.app
  }
}
