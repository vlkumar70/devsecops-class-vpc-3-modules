output "public_subnet_1a" {
  description = "Public subnet 1a"
  value       = aws_subnet.public-subnet-1a.id
}

output "vpc_id" {
  description = "Public subnet 1a"
  value       = aws_vpc.devops-vpc.id
}
