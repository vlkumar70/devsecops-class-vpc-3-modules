locals {
  availability_zone_1a = var.availability_zone_1a
  ingress_rules = [
    {
      port        = 22
      description = "Ingress rule for port 22"
    },
    {
      port        = 80
      description = "Ingress rule for port 80"
    },
    {
      port        = 443
      description = "Ingress rule for port 443"
    },
    {
      port        = 8080
      description = "Ingress rule for port 8080"
    },
    {
      port        = 3389
      description = "Ingress rule for port 3389"
    }
  ]
}
## Security group
data "external" "whatismyip" {
  program = ["/bin/bash", "${path.module}/files/whatismyip.sh"]
}

resource "aws_security_group" "allow_ssh" {
  name        = "devsecops-public-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [format("%s/%s", data.external.whatismyip.result["internet_ip"], 32)]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# This function will get the latest ami id from AMI list
data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# This block will create the aws ec2 instance
resource "aws_instance" "devsecops-public-ec2" {
  ami                         = data.aws_ami.amazon-linux-2.id
  availability_zone           = local.availability_zone_1a
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true
  key_name                    = var.instance_keypair
  subnet_id                   = var.subnet_id
  security_groups             = [aws_security_group.allow_ssh.id]
  user_data                   = file("${path.module}/files/apache_config.sh")
  tenancy                     = "default"

  tags = merge({
    Name = var.instance_name
    },
    var.tags
  )

  depends_on = [
    aws_security_group.allow_ssh
  ]
}


## Provisionsers (null_resource, local-exec, remote-exec)
resource "null_resource" "example_provisioner" {
  triggers = {
    public_ip = aws_instance.devsecops-public-ec2.public_ip
  }

  connection {
    type  = "ssh"
    host  = aws_instance.devsecops-public-ec2.public_ip
    user  = var.ssh_user
    port  = var.ssh_port
    agent = true
  }

  # // copy our example script to the server
  # provisioner "file" {
  #   source      = "files/get-public-ip.sh"
  #   destination = "/tmp/get-public-ip.sh"
  # }

  # // change permissions to executable and pipe its output into a new file
  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/get-public-ip.sh",
  #     "/tmp/get-public-ip.sh > /tmp/public-ip",
  #   ]
  # }

  # provisioner "local-exec" {
  #   # copy the public-ip file back to CWD, which will be tested
  #   command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.ssh_user}@${aws_instance.devsecops-public-ec2.public_ip}:/tmp/public-ip public-ip"
  # }
}
