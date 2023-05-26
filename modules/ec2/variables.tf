variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "instance_name" {
  type        = string
  description = "EC2 instance name"
}

variable "instance_keypair" {
  type        = string
  description = "EC2 instance keypair"
}

variable "availability_zone_1a" {
  type        = string
  description = "availability_zone_1a"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile for the role"
}

variable "ssh_port" {
  description = "The port the EC2 Instance should listen on for SSH requests."
  type        = number
  default     = 22
}

variable "ssh_user" {
  description = "SSH user name to use for remote exec connections,"
  type        = string
  default     = "ec2-user"
}

variable "tags" {
  description = "A mapping of tags to assign"
  default     = {}
  type        = map(string)
}
