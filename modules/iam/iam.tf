# IAM Role
resource "aws_iam_role" "iam_for_ec2" {
  name               = var.iam_role_name
  tags               = var.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = var.iam_instance_profile_name
  role = aws_iam_role.iam_for_ec2.name

  depends_on = [aws_iam_role.iam_for_ec2]
}

# IAM policy document
data "aws_iam_policy_document" "policy" {
  statement {
    sid       = "SqsAndS3Access"
    effect    = "Allow"
    actions   = ["sqs:*", "s3:*"]
    resources = ["*"]
  }

  statement {
    sid       = "IamDescribe"
    effect    = "Allow"
    actions   = ["iam:Describe*"]
    resources = ["*"]
  }
}

# IAM policy
resource "aws_iam_policy" "iam_role_policy" {
  name        = var.iam_policy
  description = var.iam_policy_description
  policy      = data.aws_iam_policy_document.policy.json
}

# IAM policy attachment to role
resource "aws_iam_policy_attachment" "iam_role_policy_attach" {
  name       = var.iam_policy_attachment_name
  roles      = [aws_iam_role.iam_for_ec2.name]
  policy_arn = aws_iam_policy.iam_role_policy.arn
}

