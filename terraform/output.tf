output "alb_dns_name" {
  value = aws_alb.nodejs-app-alb.dns_name
  description = "The DNS name of the ALB"
}
