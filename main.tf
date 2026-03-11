resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = local.gw_final_tags
}

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