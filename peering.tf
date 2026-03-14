resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0
  #peer_owner_id = var.peer_owner_id
  peer_vpc_id   = data.aws_vpc.default_vpc.id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true

    accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = local.aws_peering_final_tags
}

#aws route for public route table
resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.default[count.index].id
}

#aws route for private route table
resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.default[count.index].id
}

#aws route for database route table
resource "aws_route" "databse_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.default[count.index].id
}



#aws route for destination vpc main route table subnet
resource "aws_route" "default_peering" {
  count = var.is_peering_required ? 1 : 0
  #route_table_id            = data.aws_vpc.default_vpc.main_route_table_id
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id  = aws_vpc_peering_connection.default[count.index].id
}