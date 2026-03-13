locals {
  common_tags = {
    Project = var.project
    Environment = var.environment
    terraform = "true"
  }

vpc_final_tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    },
    var.vpc_tags
    )

gw_final_tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    },
    var.gw_tags
    )

avz = slice(data.aws_availability_zones.available.names, 0, 2)


public_route_table_tags = merge(
    local.common_tags,
    {
        Name="${var.project}-${var.environment}"
    },
    var.route_table_public
)
}


