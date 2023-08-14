# Tags
variable "project" {}
variable "app" {}
variable "environment" {}

# General
variable "region" {}
variable "project_name" {}

# Load Balancer
variable "alb_security_group" {}
variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}
variable "vpc_id" {}
variable "health_check_path" {}
variable "application_instance_id" {}
variable "certificate_arn" {}
