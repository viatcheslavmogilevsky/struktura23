# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/eks_cluster
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/eks/cluster.go

# What 'id' came from:
# https://www.reddit.com/r/Terraform/comments/tur9as/comment/i3e7wy7/
# https://github.com/hashicorp/terraform-plugin-sdk/blob/v2.34.0/helper/schema/resource_data.go

resource "aws_eks_cluster" "this" {
  name = var.eks_cluster_name

  role_arn = var.eks_cluster_role_arn

  enabled_cluster_log_types = var.eks_cluster_enabled_cluster_log_types
  version                   = var.eks_cluster_version
  tags                      = var.eks_cluster_tags

  vpc_config {
    subnet_ids              = var.eks_cluster_vpc_config.subnet_ids
    endpoint_private_access = var.eks_cluster_vpc_config.endpoint_private_access
    endpoint_public_access  = var.eks_cluster_vpc_config.endpoint_public_access
    public_access_cidrs     = var.eks_cluster_vpc_config.public_access_cidrs
    security_group_ids      = var.eks_cluster_vpc_config.security_group_ids
  }

  bootstrap_self_managed_addons = var.eks_cluster_bootstrap_self_managed_addons

  dynamic "access_config" {
    for_each = var.eks_cluster_access_config != null ? [var.eks_cluster_access_config] : []
    content {
      authentication_mode                         = access_config.value.authentication_mode
      bootstrap_cluster_creator_admin_permissions = access_config.value.bootstrap_cluster_creator_admin_permissions
    }
  }

  dynamic "encryption_config" {
    for_each = var.eks_cluster_encryption_config != null ? [var.eks_cluster_encryption_config] : []
    content {
      dynamic "provider" {
        for_each = [encryption_config.value.provider]
        content {
          key_arn = provider.value.key_arn
        }
      }
      resources = encryption_config.value.resources
    }
  }

  dynamic "kubernetes_network_config" {
    for_each = var.eks_cluster_kubernetes_network_config != null ? [var.eks_cluster_kubernetes_network_config] : []
    content {
      service_ipv4_cidr = kubernetes_network_config.value.service_ipv4_cidr
      ip_family         = kubernetes_network_config.value.ip_family
    }
  }

  dynamic "outpost_config" {
    for_each = var.eks_cluster_outpost_config != null ? [var.eks_cluster_outpost_config] : []
    content {
      control_plane_instance_type = outpost_config.value.control_plane_instance_type
      dynamic "control_plane_placement" {
        for_each = outpost_config.value.control_plane_placement != null ? [outpost_config.value.control_plane_placement] : []
        content {
          group_name = control_plane_placement.value.group_name
        }
      }
      outpost_arns = outpost_config.value.outpost_arns
    }
  }

  dynamic "upgrade_policy" {
    for_each = var.eks_cluster_upgrade_policy != null ? [var.eks_cluster_upgrade_policy] : []
    content {
      support_type = upgrade_policy.value.support_type
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/tls/4.0.6/docs/data-sources/certificate
# https://github.com/hashicorp/terraform-provider-tls/blob/v4.0.6/internal/provider/data_source_certificate.go

data "tls_certificate" "this" {
  count = var.iam_openid_connect_provider != null ? 1 : 0

  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/iam_openid_connect_provider
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/iam/openid_connect_provider.go

resource "aws_iam_openid_connect_provider" "this" {
  count = var.iam_openid_connect_provider != null ? 1 : 0

  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = try(var.iam_openid_connect_provider.client_id_list)
  thumbprint_list = [one(data.tls_certificate.this[*].certificates[0].sha1_fingerprint)]
  tags            = try(var.iam_openid_connect_provider.tags)
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/eks_addon
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/eks/addon.go

resource "aws_eks_addon" "this" {
  for_each = local.merged_no_key_attrs["eks_addons"]

  cluster_name = aws_eks_cluster.this.id
  addon_name   = local.merged_key_attrs["eks_addons"][each.key].addon_name

  # enforced:
  # resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
  # resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  addon_version            = each.value.addon_version
  configuration_values     = each.value.configuration_values
  tags                     = each.value.tags
  preserve                 = each.value.preserve
  service_account_role_arn = each.value.service_account_role_arn

  depends_on = [
    aws_iam_openid_connect_provider.this,
  ]
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/eks_node_group
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/eks/node_group.go


resource "aws_eks_node_group" "this" {
  for_each = local.merged_no_key_attrs["eks_node_groups"]

  cluster_name = aws_eks_cluster.this.id

  # ..name_prefix can be found from ..name
  # suffix example: 20241118090004730600000001

  node_group_name        = local.merged_key_attrs["eks_node_groups"][each.key].node_group_name
  node_group_name_prefix = local.merged_key_attrs["eks_node_groups"][each.key].node_group_name_prefix
  node_role_arn          = each.value.node_role_arn
  subnet_ids             = each.value.subnet_ids
  ami_type               = each.value.ami_type
  capacity_type          = each.value.capacity_type
  disk_size              = each.value.disk_size
  force_update_version   = each.value.force_update_version
  instance_types         = each.value.instance_types
  labels                 = each.value.labels
  release_version        = each.value.release_version
  tags                   = each.value.tags
  version                = each.value.version

  scaling_config {
    desired_size = try(each.value.scaling_config.desired_size)
    max_size     = try(each.value.scaling_config.max_size)
    min_size     = try(each.value.scaling_config.min_size)
  }

  dynamic "launch_template" {
    for_each = each.value.launch_template != null ? [each.value.launch_template] : []
    content {
      name    = launch_template.value.launch_template_key != null ? aws_launch_template.this[launch_template.value.launch_template_key].name : launch_template.value.name
      version = launch_template.value.launch_template_key != null ? aws_launch_template.this[launch_template.value.launch_template_key].latest_version : launch_template.value.version
    }
  }

  dynamic "remote_access" {
    for_each = each.value.remote_access != null ? [each.value.remote_access] : []
    content {
      ec2_ssh_key               = remote_access.value.ec2_ssh_key
      source_security_group_ids = remote_access.value.source_security_group_ids
    }
  }

  dynamic "taint" {
    for_each = each.value.taint != null ? each.value.taint : []
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  dynamic "update_config" {
    for_each = each.value.update_config != null ? [each.value.update_config] : []
    content {
      max_unavailable            = update_config.value.max_unavailable
      max_unavailable_percentage = update_config.value.max_unavailable_percentage
    }
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/data-sources/ami
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/ec2/ec2_ami_data_source.go

data "aws_ami" "this" {
  for_each = { for key, value in local.merged_no_key_attrs["launch_templates"] : key => value.ami if value.ami != null }

  owners             = each.value.owners
  most_recent        = each.value.most_recent
  executable_users   = each.value.executable_users
  include_deprecated = each.value.include_deprecated
  name_regex         = each.value.name_regex

  # IAMHERE: what's dynamic block internal structure in statefile?
  dynamic "filter" {
    for_each = each.value.filter != null ? each.value.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/launch_template
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/ec2/ec2_launch_template.go

resource "aws_launch_template" "this" {
  for_each = local.merged_no_key_attrs["launch_templates"]

  name        = local.merged_key_attrs["launch_templates"][each.key].name
  name_prefix = local.merged_key_attrs["launch_templates"][each.key].name_prefix
  image_id    = each.value.ami != null ? data.aws_ami.this[each.key].image_id : each.value.image_id

  lifecycle {
    ignore_changes = [
      tag_specifications[0].tags["Owner"]
    ]
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash -xe

    # Bootstrap and join the cluster
    /etc/eks/bootstrap.sh --b64-cluster-ca '${aws_eks_cluster.this.certificate_authority[0].data}' --apiserver-endpoint '${aws_eks_cluster.this.endpoint}' '${aws_eks_cluster.this.id}'

    # Allow user supplied userdata code
    echo "Node is up..."
  EOT
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${aws_eks_cluster.this.id}-worker"
    }
  }

  vpc_security_group_ids = [
    aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  ]

  dynamic "block_device_mappings" {
    for_each = each.value.block_device_mappings != null ? each.value.block_device_mappings : []
    content {
      device_name = block_device_mappings.value.device_name
      dynamic "ebs" {
        for_each = block_device_mappings.value.ebs != null ? [block_device_mappings.value.ebs] : []
        content {
          delete_on_termination = ebs.delete_on_termination
          encrypted             = ebs.encrypted
          iops                  = ebs.iops
          kms_key_id            = ebs.kms_key_id
          snapshot_id           = ebs.snapshot_id
          throughput            = ebs.throughput
          volume_size           = ebs.volume_size
          volume_type           = ebs.volume_type
        }
      }
      no_device    = block_device_mappings.no_device
      virtual_name = block_device_mappings.virtual_name
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = each.value.capacity_reservation_specification != null ? [each.value.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = capacity_reservation_specification.value.capacity_reservation_preference
      dynamic "capacity_reservation_target" {
        for_each = capacity_reservation_specification.value.capacity_reservation_target != null ? [capacity_reservation_specification.value.capacity_reservation_target] : []
        content {
          capacity_reservation_id                 = capacity_reservation_target.value.capacity_reservation_id
          capacity_reservation_resource_group_arn = capacity_reservation_target.value.capacity_reservation_resource_group_arn
        }
      }
    }
  }

  dynamic "cpu_options" {
    for_each = each.value.cpu_options != null ? [each.value.cpu_options] : []
    content {
      amd_sev_snp      = cpu_options.value.amd_sev_snp
      core_count       = cpu_options.value.core_count
      threads_per_core = cpu_options.value.threads_per_core
    }
  }

  dynamic "credit_specification" {
    for_each = each.value.credit_specification != null ? [each.value.credit_specification] : []
    content {
      cpu_credits = credit_specification.value.cpu_credits
    }
  }

  default_version         = each.value.default_version
  description             = each.value.description
  disable_api_stop        = each.value.disable_api_stop
  disable_api_termination = each.value.disable_api_termination
  ebs_optimized           = each.value.ebs_optimized

  dynamic "elastic_gpu_specifications" {
    for_each = each.value.elastic_gpu_specifications != null ? each.value.elastic_gpu_specifications : []
    content {
      type = elastic_gpu_specifications.value.type
    }
  }

  dynamic "elastic_inference_accelerator" {
    for_each = each.value.elastic_inference_accelerator != null ? [each.value.elastic_inference_accelerator] : []
    content {
      type = elastic_inference_accelerator.value.type
    }
  }

  dynamic "enclave_options" {
    for_each = each.value.enclave_options != null ? [each.value.enclave_options] : []
    content {
      enabled = enclave_options.value.enabled
    }
  }

  dynamic "hibernation_options" {
    for_each = each.value.hibernation_options != null ? [each.value.hibernation_options] : []
    content {
      configured = hibernation_options.value.configured
    }
  }

  dynamic "iam_instance_profile" {
    for_each = each.value.iam_instance_profile != null ? [each.value.iam_instance_profile] : []
    content {
      arn  = each.value.arn
      name = each.value.name
    }
  }

  instance_initiated_shutdown_behavior = each.value.instance_initiated_shutdown_behavior

  dynamic "instance_market_options" {
    for_each = each.value.instance_market_options != null ? [each.value.instance_market_options] : []
    content {
      market_type = instance_market_options.value.market_type
      dynamic "spot_options" {
        for_each = instance_market_options.value.spot_options != null ? [instance_market_options.value.spot_options] : []
        content {
          block_duration_minutes         = spot_options.value.block_duration_minutes
          instance_interruption_behavior = spot_options.value.instance_interruption_behavior
          max_price                      = spot_options.value.max_price
          spot_instance_type             = spot_options.value.spot_instance_type
          valid_until                    = spot_options.value.valid_until
        }
      }
    }
  }

  dynamic "instance_requirements" {
    for_each = each.value.instance_requirements != null ? [each.value.instance_requirements] : []
    content {
      dynamic "accelerator_count" {
        for_each = instance_requirements.value.accelerator_count != null ? [instance_requirements.value.accelerator_count] : []
        content {
          max = accelerator_count.value.max
          min = accelerator_count.value.min
        }
      }

      accelerator_manufacturers = instance_requirements.value.accelerator_manufacturers
      accelerator_names         = instance_requirements.value.accelerator_names

      dynamic "accelerator_total_memory_mib" {
        for_each = instance_requirements.value.accelerator_total_memory_mib != null ? [instance_requirements.value.accelerator_total_memory_mib] : []
        content {
          max = accelerator_total_memory_mib.value.max
          min = accelerator_total_memory_mib.value.min
        }
      }

      accelerator_types      = instance_requirements.value.accelerator_types
      allowed_instance_types = instance_requirements.value.allowed_instance_types
      bare_metal             = instance_requirements.value.bare_metal

      dynamic "baseline_ebs_bandwidth_mbps" {
        for_each = instance_requirements.value.baseline_ebs_bandwidth_mbps != null ? [instance_requirements.value.baseline_ebs_bandwidth_mbps] : []
        content {
          max = baseline_ebs_bandwidth_mbps.value.max
          min = baseline_ebs_bandwidth_mbps.value.min
        }
      }

      burstable_performance                                   = instance_requirements.value.burstable_performance
      cpu_manufacturers                                       = instance_requirements.value.cpu_manufacturers
      excluded_instance_types                                 = instance_requirements.value.excluded_instance_types
      instance_generations                                    = instance_requirements.value.instance_generations
      local_storage                                           = instance_requirements.value.local_storage
      local_storage_types                                     = instance_requirements.value.local_storage_types
      max_spot_price_as_percentage_of_optimal_on_demand_price = instance_requirements.value.max_spot_price_as_percentage_of_optimal_on_demand_price

      dynamic "memory_gib_per_vcpu" {
        for_each = instance_requirements.value.memory_gib_per_vcpu != null ? [instance_requirements.value.memory_gib_per_vcpu] : []
        content {
          max = memory_gib_per_vcpu.value.max
          min = memory_gib_per_vcpu.value.min
        }
      }

      dynamic "memory_mib" {
        for_each = instance_requirements.value.memory_mib != null ? [instance_requirements.value.memory_mib] : []
        content {
          max = memory_mib.value.max
          min = memory_mib.value.min
        }
      }

      dynamic "network_bandwidth_gbps" {
        for_each = instance_requirements.value.network_bandwidth_gbps != null ? [instance_requirements.value.network_bandwidth_gbps] : []
        content {
          max = network_bandwidth_gbps.value.max
          min = network_bandwidth_gbps.value.min
        }
      }

      dynamic "network_interface_count" {
        for_each = instance_requirements.value.network_interface_count != null ? [instance_requirements.value.network_interface_count] : []
        content {
          max = network_interface_count.value.max
          min = network_interface_count.value.min
        }
      }

      on_demand_max_price_percentage_over_lowest_price = instance_requirements.value.on_demand_max_price_percentage_over_lowest_price
      require_hibernate_support                        = instance_requirements.value.require_hibernate_support
      spot_max_price_percentage_over_lowest_price      = instance_requirements.value.spot_max_price_percentage_over_lowest_price

      dynamic "total_local_storage_gb" {
        for_each = instance_requirements.value.total_local_storage_gb != null ? [instance_requirements.value.total_local_storage_gb] : []
        content {
          max = total_local_storage_gb.value.max
          min = total_local_storage_gb.value.min
        }
      }

      dynamic "vcpu_count" {
        for_each = instance_requirements.value.vcpu_count != null ? [instance_requirements.value.vcpu_count] : []
        content {
          max = vcpu_count.value.max
          min = vcpu_count.value.min
        }
      }
    }
  }

  instance_type = each.value.instance_type
  kernel_id     = each.value.kernel_id
  key_name      = each.value.key_name

  dynamic "license_specification" {
    for_each = each.value.license_specification != null ? each.value.license_specification : []
    content {
      license_configuration_arn = license_specification.value.license_configuration_arn
    }
  }

  dynamic "maintenance_options" {
    for_each = each.value.maintenance_options != null ? [each.value.maintenance_options] : []
    content {
      auto_recovery = maintenance_options.value.auto_recovery
    }
  }

  dynamic "metadata_options" {
    for_each = each.value.metadata_options != null ? [each.value.metadata_options] : []
    content {
      http_endpoint               = metadata_options.value.http_endpoint
      http_protocol_ipv6          = metadata_options.value.http_protocol_ipv6
      http_put_response_hop_limit = metadata_options.value.http_put_response_hop_limit
      http_tokens                 = metadata_options.value.http_tokens
      instance_metadata_tags      = metadata_options.value.instance_metadata_tags
    }
  }

  dynamic "monitoring" {
    for_each = each.value.monitoring != null ? [each.value.monitoring] : []
    content {
      enabled = monitoring.value.enabled
    }
  }

  dynamic "network_interfaces" {
    for_each = each.value.network_interfaces != null ? each.value.network_interfaces : []
    content {
      associate_carrier_ip_address = network_interfaces.value.associate_carrier_ip_address
      associate_public_ip_address  = network_interfaces.value.associate_public_ip_address
      delete_on_termination        = network_interfaces.value.delete_on_termination
      description                  = network_interfaces.value.description
      device_index                 = network_interfaces.value.device_index
      interface_type               = network_interfaces.value.interface_type
      ipv4_address_count           = network_interfaces.value.ipv4_address_count
      ipv4_addresses               = network_interfaces.value.ipv4_addresses
      ipv4_prefix_count            = network_interfaces.value.ipv4_prefix_count
      ipv4_prefixes                = network_interfaces.value.ipv4_prefixes
      ipv6_address_count           = network_interfaces.value.ipv6_address_count
      ipv6_addresses               = network_interfaces.value.ipv6_addresses
      ipv6_prefix_count            = network_interfaces.value.ipv6_prefix_count
      ipv6_prefixes                = network_interfaces.value.ipv6_prefixes
      network_card_index           = network_interfaces.value.network_card_index
      network_interface_id         = network_interfaces.value.network_interface_id
      primary_ipv6                 = network_interfaces.value.primary_ipv6
      private_ip_address           = network_interfaces.value.private_ip_address
      security_groups              = network_interfaces.value.security_groups
      subnet_id                    = network_interfaces.value.subnet_id
    }
  }

  dynamic "placement" {
    for_each = each.value.placement != null ? [each.value.placement] : []
    content {
      affinity                = placement.value.affinity
      availability_zone       = placement.value.availability_zone
      group_name              = placement.value.group_name
      host_id                 = placement.value.host_id
      host_resource_group_arn = placement.value.host_resource_group_arn
      partition_number        = placement.value.partition_number
      spread_domain           = placement.value.spread_domain
      tenancy                 = placement.value.tenancy
    }
  }

  dynamic "private_dns_name_options" {
    for_each = each.value.private_dns_name_options != null ? [each.value.private_dns_name_options] : []
    content {
      enable_resource_name_dns_aaaa_record = private_dns_name_options.value.enable_resource_name_dns_aaaa_record
      enable_resource_name_dns_a_record    = private_dns_name_options.value.enable_resource_name_dns_a_record
      hostname_type                        = private_dns_name_options.value.hostname_type
    }
  }

  ram_disk_id          = each.value.ram_disk_id
  security_group_names = each.value.security_group_names

  # dynamic "tag_specifications" {
  #   for_each = each.value.tag_specifications != null ? each.value.tag_specifications : []
  #   content {
  #     resource_type = tag_specifications.value.resource_type
  #     tags          = tag_specifications.value.tags
  #   }
  # }

  tags                   = each.value.tags
  update_default_version = each.value.update_default_version
  # vpc_security_group_ids = each.value.vpc_security_group_ids
}
