module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 4.0"

  name = var.name
  cidr = var.vpc_cidr

  create_igw = true

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  intra_subnets   = var.intra_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # Required for public EKS nodes. 
  map_public_ip_on_launch = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"               = 1
    "kubernetes.io/cluster/${var.name}" = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                        = 1
    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}