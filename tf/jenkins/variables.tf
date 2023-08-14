# Tags
variable "project" {}
variable "app" {}
variable "environment" {}

# General
variable "region" {}
variable "project_name" {}

# Application
variable "domain_name" {}
variable "subdomain_name" {}
variable "health_check_path" {}

# VPC
variable "vpc_cidir" {}
variable "public_subnet_az1_cidir" {}
variable "public_subnet_az2_cidir" {}

# Route 53
variable "record_name" {}

# EC2
variable "e2_instance_key_name" {}





