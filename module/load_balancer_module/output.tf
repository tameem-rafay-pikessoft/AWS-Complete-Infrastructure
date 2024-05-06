output "load_balancer_name" {
  value = aws_lb.elastic_load_balancer.name
}

output "load_balancer_url" {
  value = aws_lb.elastic_load_balancer.dns_name
}

output "elb_security_group_id" {
  value = aws_security_group.elb_sg.id
}
