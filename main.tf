module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.7"

  name = "${var.project}-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  private_subnets = [for i, az in slice(data.aws_availability_zones.available.names, 0, var.az_count) : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnets  = [for i, az in slice(data.aws_availability_zones.available.names, 0, var.az_count) :
  cidrsubnet(var.vpc_cidr, 8, 128 + i)  ]


  enable_nat_gateway = true
  single_nat_gateway = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

data "aws_availability_zones" "available" {}
