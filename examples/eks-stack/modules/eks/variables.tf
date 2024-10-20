variable "eks_cluster_name" {
  description = "The name of the eks cluster."
  type        = string
}

variable "eks_cluster_version" {
  description = "Desired k8s version"
  type        = string
  default     = "1.29"
}

variable "eks_role_arn" {
  description = "ARN of the EKS role."
  type        = string
}

variable "eks_enabled_log_types" {
  description = "The enabled log types of the EKS cluster."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "eks_tags" {
  description = "Tags of the EKS Cluster."
  type        = map(any)
}

variable "eks_subnet_ids" {
  description = "Subnet IDS of the eks subnet."
  type        = list(string)
}

variable "eks_endpoint_private_access" {
  description = "Make the private endpoints in EKS available."
  type        = bool
  default     = false
}

variable "eks_endpoint_public_access" {
  description = "Make the public endpoints in EKS available."
  type        = bool
  default     = true
}

variable "eks_public_access_cidrs" {
  description = "Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_security_group_ids" {
  description = "EKS Security Groups"
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
  description = "Instance types of the node group (t3.medium, c5,xlarge etc.)"
  type        = string
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
