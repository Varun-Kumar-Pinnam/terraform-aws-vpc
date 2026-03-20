data "aws_availability_zones" "available" {
  state = "available"
}


data "aws_vpc" "default_vpc" {
  default = true
}

#fetching the aws route table data to associat in peering connection
data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.default_vpc.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

