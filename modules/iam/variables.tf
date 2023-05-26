variable "iam_role_name" {
  type        = string
  description = "IAM Role name"
}

variable "iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile for the role"
}

variable "iam_policy" {
  type        = string
  description = "IAM policy name"
}

variable "iam_policy_description" {
  type        = string
  description = "IAM policy description"
}

variable "iam_policy_attachment_name" {
  type        = string
  description = "IAM policy description"
}

variable "tags" {
  description = "A mapping of tags to assign"
  default     = {}
  type        = map(string)
}