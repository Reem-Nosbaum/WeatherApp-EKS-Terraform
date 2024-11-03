variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "oidc_issuer" {
  description = "The OIDC issuer URL for the cluster"
  type        = string
}

variable "helm_version" {
  description = "The version of the aws-load-balancer-controller chart"
  type        = string
  default     = "1.2.0"
}
