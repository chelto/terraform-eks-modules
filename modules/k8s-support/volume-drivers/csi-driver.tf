
locals {
  efs_csi_sa = "efs-csi-controller-sa"
}

# create role for CSI controler pod to assume and allow to contect oidc
# EFS 
module "efs_csi_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.5"
  role_name             = "${var.cluster_name}-efs-csi-role"
  attach_efs_csi_policy = true
  oidc_providers = {
    ex = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:efs-csi-controller-sa"]
    }
  }
}

# EFS driver deployment
resource "helm_release" "efs_csi" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  version    = "2.4.1"
  namespace  = var.namespace

  values = [yamlencode({
    resources = {
      limits = {
        cpu    = "100m"
        memory = "100Mi"
      }
      requests = {
        cpu    = "10m"
        memory = "20Mi"
      }
    }
    controller = {
      serviceAccount = {
        name = local.efs_csi_sa
        annotations = {
          "eks.amazonaws.com/role-arn" = module.efs_csi_irsa_role.iam_role_arn
        }
      }
    }
  })]
}


# create k8s storage class EFS
resource "kubernetes_storage_class" "efs_csi" {
  metadata {
    name = "efs-sc"
  }
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = var.efs_id
    directoryPerms   = "700"
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
}


# create role for CSI controler pod to assume and allow to contect oidc
# EBS 
module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name             = "${var.cluster_name}-ebs-csi"
  attach_ebs_csi_policy = true
  oidc_providers = {
    ex = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}
