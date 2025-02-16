provider "aws" {
    region = "us-east-1"
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

data "aws_availability_zones" "azs" {}

module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block

  /* Will make sure there is one public & private subnet in each AZ */

  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  
  /* Distributes the private and public subnets in each AZ (which should be 2 AZs) */

  azs = data.aws_availability_zones.azs.names 

  enable_nat_gateway = true

  /* Single NAT gateway creates a shared common NAT gateway for all the private subnets
    so their internet traffic can be routed through this shared NAT Gateway */
  single_nat_gateway = true
  enable_dns_hostnames = true

  /* These tags are crucial for the AWS Cloud Controller Manager (CCM which is part of the EKS control plane) 
  to identify which VPC and subnets (along with other resources) belong to the EKS cluster */
  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

}