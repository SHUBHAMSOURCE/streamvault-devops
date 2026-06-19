output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "backend_role_arn" {
  description = "ARN of the backend IAM role"
  value       = aws_iam_role.backend_role.arn
}
