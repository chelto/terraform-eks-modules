

variable "public_subnets" {
  type = list

}
variable "private_subnets" {
  type = list
}

variable "vpc_cidr_range" {
  type = string
}


variable "cluster_name" {
  type = string

}

variable "vpc_id" {
  type = string

}

variable "ingress_sg_id" {
  type = string

}

variable "efs_enable_encryption" {
  type = bool
  default = true
}

variable "efs_kms_key_arn" {
  type = string
  default = null // Defaults to aws/elasticfilesystem
}

variable "efs_performance_mode" {
  type = string
  default = "generalPurpose" // alternative is maxIO
}

variable "efs_throughput_mode" {
  type = string
  default = "bursting" // alternative is provisioned
}

variable "efs_provisioned_throughput_in_mibps" {
  type = number
  default = null // might need to be 0
}

variable "efs_ia_lifecycle_policy" {
  type = string
  default = null // Valid values are AFTER_7_DAYS AFTER_14_DAYS AFTER_30_DAYS AFTER_60_DAYS AFTER_90_DAYS
}


variable "efs_access_point_uid" {
  type        = number
  description = "The uid number to associate with the EFS access point" // graphana 1000
  default     = 1000
}

variable "efs_access_point_gid" {
  type        = number
  description = "The gid number to associate with the EFS access point" // graphana 1000
  default     = 1000
}

variable "tags" {
  type        = map(string)
  description = "tag inheritance"
}

