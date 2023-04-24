
variable "eks_oidc_provider_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "efs_id" {
  type = string
}

variable "namespace" {
  type = string
}

# local.efs_csi_sa
# variable "efs_csi_sa" {
#   type = string
# }