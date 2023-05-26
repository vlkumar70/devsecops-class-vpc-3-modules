locals {
  availability_zone_1a = var.availability_zone_1a
  availability_zone_1b = var.availability_zone_1b
  availability_zone_1c = var.availability_zone_1c
}
# 1. VPC
resource "aws_vpc" "devops-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({
    Name = var.vpc_name
    },
    var.tags
  )
}

## 2. Create Subnets

# # ## Availability Zone (1a) - public-subnet-1a, application-private-1a, database-private-1a
resource "aws_subnet" "public-subnet-1a" {
  vpc_id                  = aws_vpc.devops-vpc.id ## Implicit dependency
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet_1a_cidr
  availability_zone       = local.availability_zone_1a

  tags = merge({
    Name = var.public_subnet_1a
    },
    var.tags
  )

  # Explicit dependency
  depends_on = [aws_vpc.devops-vpc]
}

resource "aws_subnet" "application-private-1a" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.application_private_1a_cidr
  availability_zone       = local.availability_zone_1a


  tags = merge({
    Name = var.application_private_1a
    },
    var.tags
  )
  depends_on = [aws_vpc.devops-vpc]
}

resource "aws_subnet" "database-private-1a" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.database_private_1a_cidr
  availability_zone       = local.availability_zone_1a


  tags = merge({
    Name = var.database_private_1a
    },
    var.tags
  )

  depends_on = [aws_vpc.devops-vpc]
}

# # ## Availability Zone (1b) - public-subnet-1b. application-private-1b, database-private-1b
resource "aws_subnet" "public-subnet-1b" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet_1b_cidr
  availability_zone       = local.availability_zone_1b

  tags = merge({
    Name = var.public_subnet_1b
    },
    var.tags
  )
}

resource "aws_subnet" "application-private-1b" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.application_private_1b_cidr
  availability_zone       = local.availability_zone_1b


  tags = merge({
    Name = var.application_private_1b
    },
    var.tags
  )
  depends_on = [aws_vpc.devops-vpc]
}

resource "aws_subnet" "database-private-1b" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.database_private_1b_cidr
  availability_zone       = local.availability_zone_1b

  tags = merge({
    Name = var.database_private_1b
    },
    var.tags
  )
  depends_on = [aws_vpc.devops-vpc]
}

# # ## Availability Zone (1c) - public-subnet-1c. application-private-1c, database-private-1c
resource "aws_subnet" "public-subnet-1c" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet_1c_cidr
  availability_zone       = local.availability_zone_1c


  tags = merge({
    Name = var.public_subnet_1c
    },
    var.tags
  )
  depends_on = [aws_vpc.devops-vpc]
}

resource "aws_subnet" "application-private-1c" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.application_private_1c_cidr
  availability_zone       = local.availability_zone_1c

  tags = merge({
    Name = var.application_private_1c
    },
    var.tags
  )
  depends_on = [aws_vpc.devops-vpc]
}

resource "aws_subnet" "database-private-1c" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.database_private_1c_cidr
  availability_zone       = local.availability_zone_1c

  tags = merge({
    Name = var.database_private_1c
    },
    var.tags
  )
  depends_on = [aws_vpc.devops-vpc]
}


# # ## Route table
resource "aws_route_table" "devops-public-rt" {
  vpc_id = aws_vpc.devops-vpc.id ## Implicit dependency

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-igw.id
  }

  tags = merge({
    Name = var.public_route_table
    },
    var.tags
  )

  depends_on = [aws_vpc.devops-vpc,
    aws_subnet.public-subnet-1a,
    aws_subnet.public-subnet-1b,
  aws_subnet.public-subnet-1c]
}

resource "aws_route_table" "devops-application-rt" {
  vpc_id = aws_vpc.devops-vpc.id

  tags = merge({
    Name = var.application_route_table
    },
    var.tags
  )
  depends_on = [aws_vpc.devops-vpc,
    aws_subnet.application-private-1a,
    aws_subnet.application-private-1b,
  aws_subnet.application-private-1c]

}

resource "aws_route_table" "devops-database-rt" {
  vpc_id = aws_vpc.devops-vpc.id

  tags = merge({
    Name = var.database_route_table
    },
    var.tags
  )

  depends_on = [aws_vpc.devops-vpc,
    aws_subnet.database-private-1a,
    aws_subnet.database-private-1b,
  aws_subnet.database-private-1c]

}

resource "aws_route_table_association" "public-association-1" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.devops-public-rt.id

  depends_on = [aws_subnet.public-subnet-1a, aws_route_table.devops-public-rt]
}

resource "aws_route_table_association" "public-association-2" {
  subnet_id      = aws_subnet.public-subnet-1b.id
  route_table_id = aws_route_table.devops-public-rt.id

  depends_on = [aws_subnet.public-subnet-1b, aws_route_table.devops-public-rt]
}

resource "aws_route_table_association" "public-association-3" {
  subnet_id      = aws_subnet.public-subnet-1c.id
  route_table_id = aws_route_table.devops-public-rt.id

  depends_on = [aws_subnet.public-subnet-1c, aws_route_table.devops-public-rt]
}

resource "aws_route_table_association" "application-association-1" {
  subnet_id      = aws_subnet.application-private-1a.id
  route_table_id = aws_route_table.devops-application-rt.id

  depends_on = [aws_subnet.application-private-1a, aws_route_table.devops-application-rt]

}

resource "aws_route_table_association" "application-association-2" {
  subnet_id      = aws_subnet.application-private-1b.id
  route_table_id = aws_route_table.devops-application-rt.id

  depends_on = [aws_subnet.application-private-1b, aws_route_table.devops-application-rt]

}

resource "aws_route_table_association" "application-association-3" {
  subnet_id      = aws_subnet.application-private-1c.id
  route_table_id = aws_route_table.devops-application-rt.id

  depends_on = [aws_subnet.application-private-1c, aws_route_table.devops-application-rt]
}

resource "aws_route_table_association" "database-association-1" {
  subnet_id      = aws_subnet.database-private-1a.id
  route_table_id = aws_route_table.devops-database-rt.id
}

resource "aws_route_table_association" "database-association-2" {
  subnet_id      = aws_subnet.database-private-1b.id
  route_table_id = aws_route_table.devops-database-rt.id
}

resource "aws_route_table_association" "database-association-3" {
  subnet_id      = aws_subnet.database-private-1c.id
  route_table_id = aws_route_table.devops-database-rt.id
}


# ## IGW
resource "aws_internet_gateway" "devops-igw" {
  vpc_id = aws_vpc.devops-vpc.id

  tags = merge({
    Name = var.igw_name
    },
    var.tags
  )

  depends_on = [aws_vpc.devops-vpc]
}

