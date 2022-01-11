# # AWS VPC configuration

# resresource "aws_vpc" "vpc" {
#   cidr_blocks          = "10.0.0.0/16"
#   instance_tenancy     = "default"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags = {
#     Name = "terraform-vpc"
#   }

# }

# # Subnets for the VPC
# resource "aws_subnet" "vpc-public-1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-east-1b"
#   tags = {
#     Name = "terraform-vpc-public-1"
#   }
# }

# resource "aws_subnet" "vpc-public-2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-east-1c"
#   tags = {
#     Name = "terraform-vpc-public-2"
#   }
# }

# resource "aws_subnet" "vpc-private" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.3.0/24"
#   map_public_ip_on_launch = false
#   availability_zone       = "us-east-1c"
#   tags = {
#     Name = "terraform-private"
#   }
# }

# # Internet gateway for the VPC
# resource "aws_internet_gateway" "vpc-igw" {
#   vpc_id = aws_vpc.vpc.id
#   tags = {
#     Name = "terraform-vpc-igw"
#   }
# }

# # Routing table for the VPC
# resource "aws_route_table" "vpc-public-rt" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.vpc-igw.id
#   }

#   tags = {
#     Name = "terraform-vpc-public-rt"
#   }
# }

# # Routing associations for the VPC
# resource "aws_route_table_association" "vpc-public-1" {
#   subnet_id      = aws_subnet.vpc-public-1.id
#   route_table_id = aws_route_table.vpc-public-rt.id
# }

# resource "aws_route_table_association" "vpc-public-2" {
#   subnet_id      = aws_subnet.vpc-public-2.id
#   route_table_id = aws_route_table.vpc-public-rt.id
# }
