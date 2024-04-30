output "load_balancer_name" {
  value = aws_lb.elastic_load_balancer.name
}

output "load_balancer_url" {
  value = aws_lb.elastic_load_balancer.dns_name
}
