variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.29"
}

variable "subnet_ids" {
  description = "Subnets for EKS cluster and node group"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Max number of nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Min number of nodes"
  type        = number
  default     = 1
}

variable "instance_types" {
  description = "EC2 instance types for node group"
  type        = list(string)
  default     = ["t3.medium"]
}
