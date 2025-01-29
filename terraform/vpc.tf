module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "myvpro-vpc"
  cidr = "172.22.0.0/16"

  //azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["172.22.1.0/24", "172.22.2.0/24", "172.22.3.0/24"]
  public_subnets  = ["172.22.11.0/24", "172.22.12.0/24", "172.22.13.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true

   public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = {
    Terraform = "true"
    Environment = "stage"
  }
}