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
}

#aws route for public subnet
resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  vpc_peering_connection_id  = data.aws_vpc.default_vpc.cidr_block
}