# eks_cluster

variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type    = string
  default = null
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "eks_cluster_enabled_cluster_log_types" {
  type    = list(string)
  default = null
}

variable "eks_cluster_tags" {
  type    = map(string)
  default = null
}

variable "eks_cluster_vpc_config" {
  type = object({
    subnet_ids              = list(string)
    endpoint_private_access = optional(bool)
    endpoint_public_access  = optional(bool)
    public_access_cidrs     = optional(list(string))
    security_group_ids      = optional(list(string))
  })
}

variable "eks_cluster_bootstrap_self_managed_addons" {
  type    = bool
  default = true
}

variable "eks_cluster_access_config" {
  type = object({
    authentication_mode                         = optional(string)
    bootstrap_cluster_creator_admin_permissions = optional(bool)
  })

  default = null
}

variable "eks_cluster_encryption_config" {
  type = object({
    provider = object({
      key_arn = string
    })
    resources = list(string)
  })

  default = null
}

variable "eks_cluster_kubernetes_network_config" {
  type = object({
    service_ipv4_cidr = optional(string)
    ip_family         = optional(string)
  })

  default = null
}

variable "eks_cluster_outpost_config" {
  type = object({
    control_plane_instance_type = string
    control_plane_placement = optional(object({
      group_name = string
    }))
    outpost_arns = list(string)
  })

  default = null
}

variable "eks_cluster_upgrade_policy" {
  type = object({
    support_type = optional(string)
  })

  default = null
}

# iam_openid_connect_provider

variable "iam_openid_connect_provider" {
  type = object({
    client_id_list = list(string)
    tags           = optional(map(string))
  })

  default = null
}

# eks_addon

variable "eks_addons" {
  type = map(object({
    enabled = optional(bool, true)

    resolve_conflicts_on_create = optional(string)
    resolve_conflicts_on_update = optional(string)
    addon_version               = optional(string)
    configuration_values        = optional(string)
    tags                        = optional(map(string))
    preserve                    = optional(bool)
    service_account_role_arn    = optional(string)

    additional_tags             = optional(map(string))
  }))

  default = {}
}

variable "eks_addons_common" {
  type = object({
    enabled = optional(bool, true)

    resolve_conflicts_on_create = optional(string)
    resolve_conflicts_on_update = optional(string)
    addon_version               = optional(string)
    configuration_values        = optional(string)
    tags                        = optional(map(string))
    preserve                    = optional(bool)
    service_account_role_arn    = optional(string)
  })

  default = {
    enabled = true
  }
}

# eks_node_group

# use preconditions?
# https://developer.hashicorp.com/terraform/language/expressions/custom-conditions#preconditions-and-postconditions

variable "eks_node_groups" {
  type = map(object({
    enabled = optional(bool, true)
    use_key_as = optional(string, "node_group_name_prefix")

    node_role_arn = optional(string)
    scaling_config = optional(object({
      desired_size = number
      max_size = number
      min_size = number
    }))
    subnet_ids = optional(list(string))

    ami_type = optional(string)
    capacity_type = optional(string)
    disk_size = optional(number)
    force_update_version = optional(bool)
    instance_types = optional(list(string))
    labels = optional(map(string))
    launch_template = optional(object({
      # id = optional(string) - name is enforced
      name = optional(string)
      version = optional(string) # because it is enforced
      launch_template_key = optional(string) # belongs_to
    }))
    release_version = optional(string)
    remote_access = optional(object({
      ec2_ssh_key = optional(string)
      source_security_group_ids = optional(list(string))
    }))
    tags = optional(map(string))
    taint = optional(set(object({
      key = string
      value = optional(string)
      effect = optional(string)
    })))
    update_config = optional(object({
      max_unavailable = optional(number)
      max_unavailable_percentage = optional(number)
    }))
    version = optional(string)

    additional_subnet_ids = optional(list(string), [])
    additional_instance_types = optional(list(string), [])
    additional_taint = optional(set(object({
      key = string
      value = optional(string)
      effect = optional(string)
    })), [])
    additional_labels = optional(map(string), {})
    additional_tags = optional(map(string), {})
  }))

  default = {}
}

variable "eks_node_groups_common" {
  type = object({
    enabled = optional(bool, true)

    node_role_arn = optional(string)
    scaling_config = optional(object({
      desired_size = number
      max_size = number
      min_size = number
    }))
    subnet_ids = optional(list(string))

    ami_type = optional(string)
    capacity_type = optional(string)
    disk_size = optional(number)
    force_update_version = optional(bool)
    instance_types = optional(list(string))
    labels = optional(map(string))
    launch_template = optional(object({
      # id = optional(string) - name is enforced
      name = optional(string)
      version = optional(string) # because it is enforced
      launch_template_key = optional(string) # belongs_to
    }))
    release_version = optional(string)
    remote_access = optional(object({
      ec2_ssh_key = optional(string)
      source_security_group_ids = optional(list(string))
    }))
    tags = optional(map(string))
    taint = optional(set(object({
      key = string
      value = optional(string)
      effect = optional(string)
    })))
    update_config = optional(object({
      max_unavailable = optional(number)
      max_unavailable_percentage = optional(number)
    }))
    version = optional(string)
  })

  default = {
    enabled = true
  }
}

variable "launch_templates" {
  type = map(object({
    enabled = optional(bool, true)

    block_device_mappings = optional(list(object({
      device_name = optional(string)
      ebs = optional(object({
        delete_on_termination = optional(bool) # nullable.TypeNullableBool
        encrypted = optional(bool) # nullable.TypeNullableBool
        iops = optional(number)
        kms_key_id = optional(string)
        snapshot_id = optional(string)
        throughput = optional(number)
        volume_size = optional(number)
        volume_type = optional(string)
      }))
      no_device = optional(string)
      virtual_name = optional(string)
    })))

    capacity_reservation_specification = optional(object({
      capacity_reservation_preference = optional(string)
      capacity_reservation_target = optional(object({
        capacity_reservation_id = optional(string)
        capacity_reservation_resource_group_arn = optional(string)
      }))
    }))

    cpu_options = optional(object({
      amd_sev_snp = optional(string)
      core_count = optional(number)
      threads_per_core = optional(number)
    }))

    credit_specification = optional(object({
      cpu_credits = optional(string)
    }))

    default_version = optional(number)
    description = optional(string)
    disable_api_stop = optional(bool)
    disable_api_termination = optional(bool)
    ebs_optimized = optional(bool) # nullable.TypeNullableBool

    elastic_gpu_specifications = optional(list(object({
      type = string
    })))

    elastic_inference_accelerator = optional(object({
      type = string
    }))

    enclave_options = optional(object({
      enabled = optional(bool)
    }))

    hibernation_options = optional(object({
      configured = bool
    }))

    iam_instance_profile = optional(object({
      arn = optional(string)
      name = optional(string)
    }))

    image_id = optional(string)
  }))

  default = {}
}

variable "launch_templates_common" {
  type = object({
    enabled = optional(bool, true)

  })

  default = {
    enabled = true
  }
}

# WIP: node_groups, launch_templates, AMIs

# variable "eks_node_group_name" {
#   description = "The name of the node group"
#   type        = string
# }

# variable "eks_node_role_arn" {
#   description = "Role ARN of the EKS nodes"
#   type        = string
# }

# variable "eks_node_group_subnet_ids" {
#   description = "Subnet IDs of the node groups"
#   type        = list(string)
# }

# variable "eks_node_group_desired_size" {
#   description = "Desired size of the eks node group"
#   type        = number
# }

# variable "eks_node_group_max_size" {
#   description = "Max size of the node group"
#   type        = number
# }

# variable "eks_node_group_capacity_type" {
#   description = "Type of capacity associated with the EKS Node Group."
#   default     = "ON_DEMAND"
#   type        = string
# }
# variable "eks_node_group_min_size" {
#   description = "Minimum size of the node group"
#   type        = number
# }

# variable "eks_node_group_instance_type" {
#   description = "Instance types of the node group (t3.medium, c5.xlarge etc.)"
#   type        = string
# }

# variable "eks_node_group_instance_types" {
#   description = "Override instance types of the node group by multiple types ([t3.medium, c5.xlarge] etc.)"
#   type        = list(string)
#   default     = null
# }

# variable "eks_node_group_labels" {
#   description = "Labels of the node group"
#   type        = map(any)
# }

# variable "eks_node_group_ssh_key" {
#   description = "SSH key for the nodes"
#   type        = string
# }

# variable "eks_node_group_launch_template_name" {
#   description = "Launch template name"
#   type        = string
# }
