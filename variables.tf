
variable "cluster_endpoint_public_access_cidrs" {
  description = "a list of ips to limit access to public control plane api"
  type        = list(string)
  default = [
    "101.167.184.0/32", "102.129.134.0/20"
  ]
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  type    = string
  default = "Training"
}

variable "tags" {
  description = "Aditional tags to add to the cluster"
  type        = map(string)
  default = {
    Terraform   = "true"
    Project     = "EKS_Expiriments"
    Environment = "Training"
    Product     = "Dove"
  }
}

variable "product" {
  type    = string
  default = "Dove"
}



locals {
  # cluster_name = "education-eks-${random_string.suffix.result}"
  cluster_name = "education-eks"
}

variable "efs_create" {
  description = "create efs"
  type        = bool
  default     = false
}

variable "vpc_cidr_range" {
  description = "cidr range for vpc"
  type        = string
  default     = "10.0.0.0/16"
}
