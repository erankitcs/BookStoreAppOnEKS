resource "aws_subnet" "subneta_secondary_cidr" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block = "100.64.0.0/19"
  availability_zone = "${data.aws_region.current.name}a"
  tags = {
    Name = "${local.cluster_name}-cluster/SecondaryPrivateSubnet${data.aws_region.current.name}A"
    "alpha.eksctl.io/cluster-name" = local.cluster_name
    "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = local.cluster_name
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "subnetb_secondary_cidr" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block = "100.64.32.0/19"
  availability_zone = "${data.aws_region.current.name}b"
  tags = {
    Name = "${local.cluster_name}-cluster/SecondaryPrivateSubnet${data.aws_region.current.name}B"
    "alpha.eksctl.io/cluster-name" = local.cluster_name
    "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = local.cluster_name
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "subnetc_secondary_cidr" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block = "100.64.64.0/19"
  availability_zone = "${data.aws_region.current.name}c"
  tags = {
    Name = "${local.cluster_name}-cluster/SecondaryPrivateSubnet${data.aws_region.current.name}C"
    "alpha.eksctl.io/cluster-name" = local.cluster_name
    "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = local.cluster_name
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_route_table" "secondary_route_a" {
  vpc_id = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id

  route = []

  tags = {
    Name = "${local.cluster_name}-cluster/SecondaryPrivateSubnet${data.aws_region.current.name}A"
    "alpha.eksctl.io/cluster-name" = local.cluster_name
    "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = local.cluster_name
  }
}

resource "aws_route_table" "secondary_route_b" {
  vpc_id = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id

  route = []

  tags = {
    Name = "${local.cluster_name}-cluster/SecondaryPrivateSubnet${data.aws_region.current.name}B"
    "alpha.eksctl.io/cluster-name" = local.cluster_name
    "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = local.cluster_name
  }
}

resource "aws_route_table" "secondary_route_c" {
  vpc_id = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id

  route = []

  tags = {
    Name = "${local.cluster_name}-cluster/SecondaryPrivateSubnet${data.aws_region.current.name}C"
    "alpha.eksctl.io/cluster-name" = local.cluster_name
    "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = local.cluster_name
  }
}

resource "aws_route" "route_a" {
  route_table_id            = aws_route_table.secondary_route_a.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = module.vpc.natgw_ids[0]
}

resource "aws_route" "route_b" {
  route_table_id            = aws_route_table.secondary_route_b.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = module.vpc.natgw_ids[0]
}

resource "aws_route" "route_c" {
  route_table_id            = aws_route_table.secondary_route_c.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = module.vpc.natgw_ids[0]
}