output "avz_names" {
    value = data.aws_availability_zones.available  
}

output "igw_id" {
    value = aws_internet_gateway.gw
  
}

output "default_vpc" {

    value = data.aws_vpc.default_vpc
  
}

output "vpc_id" {
    value = aws_vpc.main.id  
}