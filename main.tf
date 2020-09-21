terraform {
  required_version = ">= 0.12"
}


data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet" "subnet" {
  count  = length(var.subnets)
  id     = var.subnets[count.index]
  vpc_id = data.aws_vpc.vpc.id
  // map_public_ip_on_launch = false
  // availability_zone       = element(data.aws_availability_zones.available.names, count.index)
}

locals {
  naming = join("", [var.entity, var.environment, var.geo_region, "hsm", var.app_name, var.function, var.sequence])
}

resource "aws_cloudhsm_v2_cluster" "cloudhsm_cluster" {
  depends_on = [data.aws_subnet.subnet]
  count      = var.create_cluster ? 1 : 0
  hsm_type   = "hsm1.medium"
  subnet_ids = data.aws_subnet.subnet.*.id

  tags = {
    "Name"          = local.naming
    "Product"       = var.product
    "Cost Center"   = var.cost_center
    "Channel"       = var.channel
    "Description"   = var.description
    "Tracking Code" = var.tracking_code
    "CIA"           = var.cia
  }
}

data "aws_cloudhsm_v2_cluster" "cluster" {
  depends_on = [aws_cloudhsm_v2_cluster.cloudhsm_cluster]
  cluster_id = var.create_cluster ? aws_cloudhsm_v2_cluster.cloudhsm_cluster[0].cluster_id : var.cluster_id
  //  depends_on = [aws_cloudhsm_v2_cluster.cloudhsm_cluster]
}

resource "aws_cloudhsm_v2_hsm" "hsm" {
  depends_on = [data.aws_subnet.subnet, data.aws_cloudhsm_v2_cluster.cluster]
  count      = length(data.aws_subnet.subnet)
  subnet_id  = data.aws_subnet.subnet[count.index].id
  // cluster_id = var.create_cluster ? data.aws_cloudhsm_v2_cluster.cluster[count.index].cluster_id : var.cluster_id
  cluster_id = data.aws_cloudhsm_v2_cluster.cluster.cluster_id
}
