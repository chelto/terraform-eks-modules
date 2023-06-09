terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }
  }
  backend "s3" {
    region  = "eu-west-2"
    profile = "default"
    key     = "terraformstatefile-eks-cluster-example"
    bucket  = "mybucket"
  }
  required_version = "~> 1.3"
}


