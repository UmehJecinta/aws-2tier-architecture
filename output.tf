output "alb_dns_name" {
  description = "Public ALB DNS name"
  value       = aws_lb.aws_alb.dns_name
}

output "alb_dns_name2" {
  description = "Internal ALB DNS name"
  value       = aws_lb.aws_alb2.dns_name
}