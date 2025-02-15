#  Automated provisioning AWS EKS cluster with Terraform

A demonstration of automating EKS cluster provisioning using Infrastructure as Code with Terraform.

[Suggested: Insert project architecture diagram showing EKS cluster components]

## Technologies Used
- AWS EKS
- Terraform
- Docker
- Linux
- Git

## Project Overview
I created an automated solution to provision an Amazon EKS cluster using Terraform for infrastructure as code. This project demonstrates my ability to implement modern DevOps practices and cloud infrastructure automation.

## Infrastructure Setup

### AWS Configuration
- Set up AWS credentials and configured necessary IAM roles
- Established VPC networking with public/private subnets across multiple AZs

[Suggested: Screenshot of AWS VPC configuration/diagram]

### Terraform Implementation
- Created Terraform configuration files to define the EKS cluster infrastructure
- Implemented modular Terraform code structure for maintainability
- Successfully deployed EKS cluster using Terraform

[Suggested: Screenshot of successful Terraform apply output]

### EKS Cluster Configuration
- Configured worker nodes and node groups
- Set up cluster networking and security groups
- Implemented cluster auto-scaling capabilities

[Suggested: Screenshot of EKS cluster dashboard]

## Key Achievements
- Automated end-to-end EKS cluster provisioning
- Implemented infrastructure as code best practices
- Created reusable Terraform modules
- Ensured high availability across multiple AZs

## Getting Started

### Prerequisites
- AWS Account
- Terraform installed
- AWS CLI configured
- kubectl installed

### Deployment
1. Clone the repository
2. Initialize Terraform
3. Apply the Terraform configuration
4. Configure kubectl for cluster access

## Future Improvements
- Add monitoring and logging solutions
- Implement GitOps workflow
- Add additional security controls
- Enhance automation capabilities

[Suggested: Screenshot of running applications/services in the cluster]

<Give claude my terraform file code and have it create a mermaid chart for the project and also include the projects description>