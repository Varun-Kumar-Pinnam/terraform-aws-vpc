output "avz_names" {
    value = data.aws_availability_zones.available  
}

output "igw_id" {
    value = aws_internet_gateway.gw
  
}