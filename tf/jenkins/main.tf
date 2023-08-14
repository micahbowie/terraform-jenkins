# configure the aws provider
provider "aws" {
  region = var.region
  # replace-me
  profile = "terraform-user"
}

module "vpc" {
  source                  = "../modules/vpc"
  project                 = var.project
  app                     = var.app
  environment             = var.environment
  region                  = var.region
  project_name            = var.project_name
  vpc_cidir               = var.vpc_cidir
  public_subnet_az1_cidir = var.public_subnet_az1_cidir
  public_subnet_az2_cidir = var.public_subnet_az2_cidir
}

module "ec2_instance" {
  source                = "../modules/ec2_instance"
  project               = var.project
  app                   = var.app
  environment           = var.environment
  region                = var.region
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  ec2_security_group_id = module.security_groups.ec2_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  e2_instance_key_name  = var.e2_instance_key_name
}

module "application_load_balancer" {
  source                  = "../modules/load_balancer"
  project                 = var.project
  app                     = var.app
  environment             = var.environment
  region                  = var.region
  project_name            = var.project_name
  alb_security_group      = module.security_groups.alb_security_group_id
  public_subnet_az1_id    = module.vpc.public_subnet_az1_id
  public_subnet_az2_id    = module.vpc.public_subnet_az2_id
  vpc_id                  = module.vpc.vpc_id
  health_check_path       = var.health_check_path
  application_instance_id = module.ec2_instance.application_instance_id
  certificate_arn         = module.certificate_manager.certificate_arn
}


module "security_groups" {
  source       = "../modules/security_groups"
  project      = var.project
  app          = var.app
  environment  = var.environment
  region       = var.region
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "certificate_manager" {
  source         = "../modules/certificate_manager"
  domain_name    = var.domain_name
  subdomain_name = var.subdomain_name
}

module "route_53" {
  source                             = "../modules/route_53"
  domain_name                        = var.domain_name
  record_name                        = var.record_name
  application_load_balancer_dns_name = module.application_load_balancer.application_load_balancer_dns_name
  application_load_balancer_zone_id  = module.application_load_balancer.application_load_balancer_zone_id
}

output "website_url" {
  value = join("", ["https://", var.record_name, ".", var.domain_name])
}
