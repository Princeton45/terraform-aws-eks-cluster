module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.31"
  cluster_endpoint_public_access = true

  subnet_ids =  module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id 

  tags = {
    environment = "development"
    application = "myapp"
  }

   eks_managed_node_groups = {
    dev = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }
}
