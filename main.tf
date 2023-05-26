## Provider
provider "aws" {
  region = var.region
}

## Terraform version
terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.5"
    }
  }
}

## Terraform state backend
terraform {
  backend "s3" {
    bucket         = "tek-bucket-terraform-state"
    key            = "devsecops/nice-key1"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dev-dynamo-terraform-lock"
  }
}

## VPC module
module "vpc" {
  source                      = "./modules/vpc"
  availability_zone_1a        = var.availability_zone_1a
  availability_zone_1b        = var.availability_zone_1b
  availability_zone_1c        = var.availability_zone_1c
  vpc_name                    = var.vpc_name
  igw_name                    = var.igw_name
  public_subnet_1a            = var.public_subnet_1a
  application_private_1a      = var.application_private_1a
  database_private_1a         = var.database_private_1a
  public_subnet_1b            = var.public_subnet_1b
  application_private_1b      = var.application_private_1b
  database_private_1b         = var.database_private_1b
  public_subnet_1c            = var.public_subnet_1c
  application_private_1c      = var.application_private_1c
  database_private_1c         = var.database_private_1c
  vpc_cidr                    = var.vpc_cidr
  public_subnet_1a_cidr       = var.public_subnet_1a_cidr
  application_private_1a_cidr = var.application_private_1a_cidr
  database_private_1a_cidr    = var.database_private_1a_cidr
  public_subnet_1b_cidr       = var.public_subnet_1b_cidr
  application_private_1b_cidr = var.application_private_1b_cidr
  database_private_1b_cidr    = var.database_private_1b_cidr
  public_subnet_1c_cidr       = var.public_subnet_1c_cidr
  application_private_1c_cidr = var.application_private_1c_cidr
  database_private_1c_cidr    = var.database_private_1c_cidr
  public_route_table          = var.public_route_table
  application_route_table     = var.application_route_table
  database_route_table        = var.database_route_table
  tags                        = var.tags
}

## IAM Module
module "iam" {
  source                     = "./modules/iam"
  iam_role_name              = var.iam_role_name
  iam_instance_profile_name  = var.iam_instance_profile_name
  iam_policy                 = var.iam_policy
  iam_policy_description     = var.iam_policy_description
  iam_policy_attachment_name = var.iam_policy_attachment_name
  tags                       = var.tags
}

## EC2 module
module "ec2" {
  source               = "./modules/ec2"
  availability_zone_1a = var.availability_zone_1a
  instance_type        = var.instance_type
  instance_name        = var.instance_name
  instance_keypair     = var.instance_keypair
  vpc_id               = module.vpc.vpc_id
  iam_instance_profile = module.iam.iam_instance_profile_name
  subnet_id            = module.vpc.public_subnet_1a
  tags                 = var.tags
}
