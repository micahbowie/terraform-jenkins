output "application_load_balancer_dns_name" {
  value = aws_lb.application_load_balancer.dns_name
}

output "application_load_balancer_zone_id" {
  value = aws_lb.application_load_balancer.zone_id
}
