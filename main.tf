provider "aws" {
  region = var.region
}

locals {
  namespace  = "default"
  efs_csi_sa = "efs-csi-controller-sa"
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

#################################### efs storage #################################
module "efs" {
  # count = var.efs_create != "" ? 1 : 0
  source          = "./modules/efs"
  depends_on      = [module.vpc, module.eks]
  ingress_sg_id   = aws_security_group.eks.id
  vpc_id          = module.vpc.vpc_id
  tags            = var.tags
  cluster_name    = local.cluster_name
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  vpc_cidr_range  = var.vpc_cidr_range
}

module "csi-drivers" {
  # count = var.efs_create != "" ? 1 : 0
  depends_on = [
    module.efs
  ]
  source                = "./modules/k8s-support/volume-drivers"
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_name          = local.cluster_name
  efs_id                = module.efs.efs_id
  namespace             = local.namespace
}
###################################################################################


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "education-vpc"
  cidr = var.vpc_cidr_range
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
  tags = merge(var.tags, {
    Environment = var.environment
    Product     = var.product
  })

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.10.0"

  cluster_name                          = local.cluster_name
  cluster_version                       = "1.25"
  vpc_id                                = module.vpc.vpc_id
  subnet_ids                            = module.vpc.private_subnets
  cluster_endpoint_public_access        = true
  cluster_endpoint_public_access_cidrs  = var.cluster_endpoint_public_access_cidrs
  cluster_additional_security_group_ids = [aws_security_group.eks.id]


  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }
  # cluster_addons = {
  #   aws-ebs-csi-driver = {
  #     service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
  #     most_recent              = true
  #   }
  # }

  eks_managed_node_groups = {
    one = {
      name           = "node-group-1"
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 8
      desired_size   = 3
      capacity_type  = "SPOT"
      labels = {
        role = "general"
      size = "small" }
    }


    two = {
      name           = "node-group-2"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      capacity_type  = "SPOT"
      labels = {
        role = "general"
      size = "medium" }
    }
  }
  tags = merge(var.tags, {
    Environment = var.environment
    Name        = local.cluster_name
    Product     = var.product
  })


}
