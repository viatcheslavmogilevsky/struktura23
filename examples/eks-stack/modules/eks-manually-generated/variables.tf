variable "eks_cluster_name" {
  type        = string
}

variable "eks_cluster_version" {
  type        = string
  default     = "1.29"
}

variable "eks_cluster_role_arn" {
  type        = string
}

variable "eks_cluster_enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "eks_cluster_tags" {
  type        = map(string)
}

variable "eks_cluster_vpc_config_subnet_ids" {
  type        = list(string)
}

variable "eks_cluster_vpc_config_endpoint_private_access" {
  type        = bool
  default     = false
}

variable "eks_cluster_vpc_config_endpoint_public_access" {
  type        = bool
  default     = true
}

variable "eks_cluster_vpc_config_public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_cluster_vpc_config_security_group_ids" {
  type        = list(string)
  default     = null
}










variable "eks_node_group_name" {
  description = "The name of the node group"
  type        = string
}

variable "eks_node_role_arn" {
  description = "Role ARN of the EKS nodes"
  type        = string
}

variable "eks_node_group_subnet_ids" {
  description = "Subnet IDs of the node groups"
  type        = list(string)
}

variable "eks_node_group_desired_size" {
  description = "Desired size of the eks node group"
  type        = number
}

variable "eks_node_group_max_size" {
  description = "Max size of the node group"
  type        = number
}

variable "eks_node_group_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group."
  default     = "ON_DEMAND"
  type        = string
}
variable "eks_node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
}

variable "eks_node_group_instance_type" {
  description = "Instance types of the node group (t3.medium, c5.xlarge etc.)"
  type        = string
}

variable "eks_node_group_instance_types" {
  description = "Override instance types of the node group by multiple types ([t3.medium, c5.xlarge] etc.)"
  type        = list(string)
  default     = null
}

variable "eks_node_group_labels" {
  description = "Labels of the node group"
  type        = map(any)
}

variable "eks_node_group_ssh_key" {
  description = "SSH key for the nodes"
  type        = string
}

variable "eks_node_group_launch_template_name" {
  description = "Launch template name"
  type        = string
}
