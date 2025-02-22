#  Automated provisioning AWS EKS cluster with Terraform

A demonstration of automating EKS cluster provisioning using Infrastructure as Code with Terraform.

![diagram](https://github.com/Princeton45/terraform-aws-eks-cluster/blob/main/images/diagram.png)

## Technologies Used
- AWS EKS
- Terraform
- Docker
- Linux
- Git

## Project Overview
I created an automated solution to provision an Amazon EKS cluster using Terraform for infrastructure as code. This project demonstrates my ability to implement modern DevOps practices and cloud infrastructure automation.

## Infrastructure Setup

### VPC Configuration
- I created the VPC required for EKS using the Terraform AWS VPC Module.

`vpc.tf`
```hcl
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
```

`terraform.tfvars`
```hcl
vpc_cidr_block = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
public_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
```

![vpc](https://github.com/Princeton45/terraform-aws-eks-cluster/blob/main/images/vpc.png)

![subnets](https://github.com/Princeton45/terraform-aws-eks-cluster/blob/main/images/subnets.png)

![nat-gateway](https://github.com/Princeton45/terraform-aws-eks-cluster/blob/main/images/nat.png)


### EKS Cluster Configuration with EKS Terraform Module
- Configured worker nodes and node groups
- Set up cluster networking and security groups
- Implemented cluster auto-scaling capabilities

`eks-cluster.tf`
```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.31"

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
```
![eks-cluster](https://github.com/Princeton45/terraform-aws-eks-cluster/blob/main/images/eks-cluster.png)


### Troubleshooting

Make sure that `AmazonEKSClusterAdminPolicy` access policy is attached to your IAM Principal ARN in
`Access` tab in the AWS EKS Cluster console.

If not, there will be errors telling you that you aren't able to access the nodes within the cluster,
resources, can't run commands like `kubectl get pods` etc.

(Could edit the terraform code so it automatically attaches this policy to the caller identity that is creating the cluster in the future)

![trouble](https://github.com/Princeton45/terraform-aws-eks-cluster/blob/main/images/trouble.png)
