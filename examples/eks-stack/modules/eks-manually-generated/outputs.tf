# eks_cluster

output "eks_cluster_access_config" {
  value = one(aws_eks_cluster.this.access_config[*])
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "eks_cluster_certificate_authority" {
  value = one(aws_eks_cluster.this.certificate_authority[*])
}

output "eks_cluster_cluster_id" {
  value = aws_eks_cluster.this.cluster_id
}

output "eks_cluster_created_at" {
  value = aws_eks_cluster.this.created_at
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks_cluster_identity" {
  value = one(aws_eks_cluster.this.identity[*])
}

output "eks_cluster_kubernetes_network_config" {
  value = one(aws_eks_cluster.this.kubernetes_network_config[*])
}

output "eks_cluster_platform_version" {
  value = aws_eks_cluster.this.platform_version
}

output "eks_cluster_status" {
  value = aws_eks_cluster.this.status
}

output "eks_cluster_tags_all" {
  value = aws_eks_cluster.this.tags_all
}

output "eks_cluster_upgrade_policy" {
  value = one(aws_eks_cluster.this.upgrade_policy[*])
}

output "eks_cluster_version" {
  value = aws_eks_cluster.this.version
}

output "eks_cluster_vpc_config" {
  value = one(aws_eks_cluster.this.vpc_config[*])
}

output "eks_cluster_id" {
  value = lookup(aws_eks_cluster.this, "id", null)
}

# certificate

output "certificate_id" {
  value = one(data.tls_certificate.this[*].id)
}

output "certificate_certificates" {
  value = one(data.tls_certificate.this[*].certificates)
}

# iam_openid_connect_provider

output "iam_openid_connect_provider_arn" {
  value = one(aws_iam_openid_connect_provider.this[*].arn)
}

output "iam_openid_connect_provider_tags_all" {
  value = one(aws_iam_openid_connect_provider.this[*].tags_all)
}

## because it's enforced:
output "iam_openid_connect_provider_thumbprint_list" {
  value = one(aws_iam_openid_connect_provider.this[*].thumbprint_list)
}

output "iam_openid_connect_provider_id" {
  value = one([for v in aws_iam_openid_connect_provider.this : lookup(v, "id", null)])
}

# eks_addon

output "eks_addon_arn_map" {
  value = { for k, v in aws_eks_addon.this : k => v.arn }
}

output "eks_addon_created_at_map" {
  value = { for k, v in aws_eks_addon.this : k => v.created_at }
}

output "eks_addon_modified_at_map" {
  value = { for k, v in aws_eks_addon.this : k => v.modified_at }
}

output "eks_addon_tags_all_map" {
  value = { for k, v in aws_eks_addon.this : k => v.tags_all }
}

output "eks_addon_addon_version_map" {
  value = { for k, v in aws_eks_addon.this : k => v.addon_version }
}

output "eks_addon_configuration_values_map" {
  value = { for k, v in aws_eks_addon.this : k => v.configuration_values }
}

output "eks_addon_id_map" {
  value = { for k, v in aws_eks_addon.this : k => lookup(v, "id", null) }
}

# eks_node_group

output "eks_node_group_ami_type_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.ami_type }
}

output "eks_node_group_arn_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.arn }
}

output "eks_node_group_capacity_type_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.capacity_type }
}

output "eks_node_group_disk_size_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.disk_size }
}

output "eks_node_group_instance_types_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.instance_types }
}

output "eks_node_group_launch_template_map" {
  value = { for k, v in aws_eks_node_group.this : k => one(v.launch_template[*]) }
}

output "eks_node_group_node_group_name_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.node_group_name }
}

output "eks_node_group_node_group_name_prefix_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.node_group_name_prefix }
}

output "eks_node_group_release_version_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.release_version }
}

output "eks_node_group_resources_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.resources }
}

output "eks_node_group_status_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.status }
}

output "eks_node_group_tags_all_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.tags_all }
}

output "eks_node_group_update_config_map" {
  value = { for k, v in aws_eks_node_group.this : k => one(v.update_config[*]) }
}

output "eks_node_group_version_map" {
  value = { for k, v in aws_eks_node_group.this : k => v.version }
}

output "eks_node_group_id_map" {
  value = { for k, v in aws_eks_node_group.this : k => lookup(v, "id", null) }
}

# launch_template

output "launch_template_arn_map" {
  value = { for k, v in aws_launch_template.this : k => v.arn }
}

output "launch_template_block_device_mappings_map" {
  value = { for k, v in aws_launch_template.this : k => v.block_device_mappings }
}

output "launch_template_default_version_map" {
  value = { for k, v in aws_launch_template.this : k => v.default_version }
}

output "launch_template_instance_market_options_map" {
  value = { for k, v in aws_launch_template.this : k => one(v.instance_market_options[*]) }
}

output "launch_template_latest_version_map" {
  value = { for k, v in aws_launch_template.this : k => v.latest_version }
}

output "launch_template_metadata_options_map" {
  value = { for k, v in aws_launch_template.this : k => one(v.metadata_options[*]) }
}

output "launch_template_name_map" {
  value = { for k, v in aws_launch_template.this : k => v.name }
}

output "launch_template_name_prefix_map" {
  value = { for k, v in aws_launch_template.this : k => v.name_prefix }
}

output "launch_template_tags_all_map" {
  value = { for k, v in aws_launch_template.this : k => v.tags_all }
}

## because it's enforced:
output "launch_template_image_id_map" {
  value = { for k, v in aws_launch_template.this : k => v.image_id }
}

## because it's enforced:
output "launch_template_user_data_map" {
  value = { for k, v in aws_launch_template.this : k => v.user_data }
}

## because it's enforced:
output "launch_template_tag_specifications_map" {
  value = { for k, v in aws_launch_template.this : k => v.tag_specifications }
}

## because it's enforced:
output "launch_template_vpc_security_group_ids_map" {
  value = { for k, v in aws_launch_template.this : k => v.vpc_security_group_ids }
}

output "launch_template_id_map" {
  value = { for k, v in aws_launch_template.this : k => lookup(v, "id", null) }
}

# ami

output "ami_architecture_map" {
  value = { for k, v in data.aws_ami.this : k => v.architecture }
}

output "ami_arn_map" {
  value = { for k, v in data.aws_ami.this : k => v.arn }
}

output "ami_block_device_mappings_map" {
  value = { for k, v in data.aws_ami.this : k => v.block_device_mappings }
}

output "ami_boot_mode_map" {
  value = { for k, v in data.aws_ami.this : k => v.boot_mode }
}

output "ami_creation_date_map" {
  value = { for k, v in data.aws_ami.this : k => v.creation_date }
}

output "ami_deprecation_time_map" {
  value = { for k, v in data.aws_ami.this : k => v.deprecation_time }
}

output "ami_ena_support_map" {
  value = { for k, v in data.aws_ami.this : k => v.ena_support }
}

output "ami_hypervisor_map" {
  value = { for k, v in data.aws_ami.this : k => v.hypervisor }
}

output "ami_image_id_map" {
  value = { for k, v in data.aws_ami.this : k => v.image_id }
}

output "ami_image_location_map" {
  value = { for k, v in data.aws_ami.this : k => v.image_location }
}

output "ami_image_owner_alias_map" {
  value = { for k, v in data.aws_ami.this : k => v.image_owner_alias }
}

output "ami_image_type_map" {
  value = { for k, v in data.aws_ami.this : k => v.image_type }
}

output "ami_imds_support_map" {
  value = { for k, v in data.aws_ami.this : k => v.imds_support }
}

output "ami_kernel_id_map" {
  value = { for k, v in data.aws_ami.this : k => v.kernel_id }
}

output "ami_name_map" {
  value = { for k, v in data.aws_ami.this : k => v.name }
}

output "ami_owner_id_map" {
  value = { for k, v in data.aws_ami.this : k => v.owner_id }
}

output "ami_platform_map" {
  value = { for k, v in data.aws_ami.this : k => v.platform }
}

output "ami_platform_details_map" {
  value = { for k, v in data.aws_ami.this : k => v.platform_details }
}

output "ami_product_codes_map" {
  value = { for k, v in data.aws_ami.this : k => v.product_codes }
}

output "ami_public_map" {
  value = { for k, v in data.aws_ami.this : k => v.public }
}

output "ami_ramdisk_id_map" {
  value = { for k, v in data.aws_ami.this : k => v.ramdisk_id }
}

output "ami_root_device_name_map" {
  value = { for k, v in data.aws_ami.this : k => v.root_device_name }
}

output "ami_root_device_type_map" {
  value = { for k, v in data.aws_ami.this : k => v.root_device_type }
}

output "ami_root_snapshot_id_map" {
  value = { for k, v in data.aws_ami.this : k => v.root_snapshot_id }
}

output "ami_sriov_net_support_map" {
  value = { for k, v in data.aws_ami.this : k => v.sriov_net_support }
}

output "ami_state_map" {
  value = { for k, v in data.aws_ami.this : k => v.state }
}

output "ami_state_reason_map" {
  value = { for k, v in data.aws_ami.this : k => v.state_reason }
}

output "ami_tags_map" {
  value = { for k, v in data.aws_ami.this : k => v.tags }
}

output "ami_tpm_support_map" {
  value = { for k, v in data.aws_ami.this : k => v.tpm_support }
}

output "ami_usage_operation_map" {
  value = { for k, v in data.aws_ami.this : k => v.usage_operation }
}

output "ami_virtualization_type_map" {
  value = { for k, v in data.aws_ami.this : k => v.virtualization_type }
}

output "ami_id_map" {
  value = { for k, v in data.aws_ami.this : k => lookup(v, "id", null) }
}
