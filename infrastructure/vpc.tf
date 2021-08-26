// Defines the VPC for any projects under the 'personal' scope.

// The VPC itself
resource "aws_vpc" "personal" {
    cidr_block = "10.0.0.0/16"
    enable_classiclink = false
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "vpc-personal"
    }
}

// Public subnets
resource "aws_subnet" "personal_public_1" {
    availability_zone = var.aws_az[0]
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "vpc-personal-public-1"
    }
    vpc_id = aws_vpc.personal.id
}

resource "aws_subnet" "personal_public_2" {
    availability_zone = var.aws_az[1]
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "vpc-personal-public-2"
    }
    vpc_id = aws_vpc.personal.id
}

resource "aws_subnet" "personal_public_3" {
    availability_zone = var.aws_az[2]
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "vpc-personal-public-3"
    }
    vpc_id = aws_vpc.personal.id
}

// Private subnets
resource "aws_subnet" "personal_private_1" {
    availability_zone = var.aws_az[0]
    cidr_block = "10.0.253.0/24"
    map_public_ip_on_launch = false
    tags = {
        Name = "vpc-personal-private-1"
    }
    vpc_id = aws_vpc.personal.id
}

resource "aws_subnet" "personal_private_2" {
    availability_zone = var.aws_az[1]
    cidr_block = "10.0.254.0/24"
    map_public_ip_on_launch = false
    tags = {
        Name = "vpc-personal-private-2"
    }
    vpc_id = aws_vpc.personal.id
}

resource "aws_subnet" "personal_private_3" {
    availability_zone = var.aws_az[2]
    cidr_block = "10.0.255.0/24"
    map_public_ip_on_launch = false
    tags = {
        Name = "vpc-personal-private-3"
    }
    vpc_id = aws_vpc.personal.id
}

// Internet gateway
resource "aws_internet_gateway" "personal" {
    tags = {
        Name = "igc-vpc-personal"
    }
    vpc_id = aws_vpc.personal.id
}

// Routing tables
resource "aws_route_table" "personal" {
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.personal.id
    }
    tags = {
        Name = "rtb-igc-vpc-personal"
    }
    vpc_id = aws_vpc.personal.id
}

// Routing associations
resource "aws_route_table_association" "personal-public-1-a" {
    route_table_id = aws_route_table.personal.id
    subnet_id = aws_subnet.personal_public_1.id
}
resource "aws_route_table_association" "personal-public-2-a" {
    route_table_id = aws_route_table.personal.id
    subnet_id = aws_subnet.personal_public_2.id
}
resource "aws_route_table_association" "personal-public-3-a" {
    route_table_id = aws_route_table.personal.id
    subnet_id = aws_subnet.personal_public_3.id
}