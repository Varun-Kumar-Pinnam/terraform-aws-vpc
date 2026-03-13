resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = local.vpc_final_tags
}

#aws IGW 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = local.gw_final_tags
}

#aws subnet for public
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.avz[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
     # roboshop-dev-public-us-east-1a
    {
      Name = "${var.project}-${var.environment}-public-${local.avz[count.index]}"
    },
     var.public_subnet_tags
  )
}

#aws subnet for private
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.avz[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private-${local.avz[count.index]}"
    },
    var.private_subnet_tags
  )

}

#aws subnet for database
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.avz[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-databse-${local.avz[count.index]}"
    },
    var.database_subnet_tags
  )
}
#aws route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = local.public_route_table_tags
}

#aws route table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = local.private_route_table_tags
}

#aws route table for database subnet
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = local.database_route_table_tags
}

#aws route for public subnet
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

#elastic ip
resource "aws_eip" "nat" {
  domain   = "vpc"
  tags = local.aws_eip_final_tags
}

#creating aws nat gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = local.aws_natgw_final_tags

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

#aws route for private subnet
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

#aws route for database subnet
resource "aws_route" "database" {

  route_table_id = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
  
}

#route table association of public subnet
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
 
#route table association of private subnet
 resource "aws_route_table_association" "private" {
   count = length(var.private_subnet_cidr)
   subnet_id      = aws_subnet.private[count.index].id
   route_table_id = aws_route_table.private.id
}

#route table association of database subnet
 resource "aws_route_table_association" "database" {
   count = length(var.database_subnet_cidr)
   subnet_id      = aws_subnet.database[count.index].id
   route_table_id = aws_route_table.database.id
} 
