output "avz_names" {
    value = data.aws_availability_zones.available  
}

output "igw_id" {
    value = aws_internet_gateway.gw
  
}

output "vpc_id" {
    value = aws_vpc.main.id  
}

#public subnet id for child modules
output "public_subnet_id" {
    value = aws_subnet.public[*].id
}

#private subnet id for child modules
output "private_subnet_id" {
    value = aws_subnet.private[*].id
}
#database subnet id for child modules
output "database_subnet_id" {
    value = aws_subnet.database[*].id
}