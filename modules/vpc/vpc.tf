resource "aws_vpc" "main" { cidr_block = var.vpc_cidr_block enable_dns_support = true enable_dns_hostnames = true }
resource "aws_internet_gateway" "igw" { vpc_id = aws_vpc.main.id }
resource "aws_subnet" "public" { count = length(var.public_subnets) vpc_id = aws_vpc.main.id cidr_block = var.public_subnets[count.index] availability_zone = var.availability_zones[count.index] map_public_ip_on_launch = true }
resource "aws_subnet" "private" { count = length(var.private_subnets) vpc_id = aws_vpc.main.id cidr_block = var.private_subnets[count.index] availability_zone = var.availability_zones[count.index] }
resource "aws_eip" "nat" { domain = "vpc" }
resource "aws_nat_gateway" "nat" { allocation_id = aws_eip.nat.id subnet_id = aws_subnet.public[0].id depends_on = [aws_internet_gateway.igw] }
