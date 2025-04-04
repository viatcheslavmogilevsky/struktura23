# eks_cluster

output "eks_cluster_access_config" {
  value = module.eks.eks_cluster_access_config
}

output "eks_cluster_arn" {
  value = module.eks.eks_cluster_arn
}

output "eks_cluster_certificate_authority" {
  value = module.eks.eks_cluster_certificate_authority
}

output "eks_cluster_cluster_id" {
  value = module.eks.eks_cluster_cluster_id
}

output "eks_cluster_created_at" {
  value = module.eks.eks_cluster_created_at
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_identity" {
  value = module.eks.eks_cluster_identity
}

output "eks_cluster_kubernetes_network_config" {
  value = module.eks.eks_cluster_kubernetes_network_config
}

output "eks_cluster_platform_version" {
  value = module.eks.eks_cluster_platform_version
}

output "eks_cluster_status" {
  value = module.eks.eks_cluster_status
}

output "eks_cluster_tags_all" {
  value = module.eks.eks_cluster_tags_all
}

output "eks_cluster_upgrade_policy" {
  value = module.eks.eks_cluster_upgrade_policy
}

output "eks_cluster_version" {
  value = module.eks.eks_cluster_version
}

output "eks_cluster_vpc_config" {
  value = module.eks.eks_cluster_vpc_config
}

output "eks_cluster_id" {
  value = module.eks.eks_cluster_id
}

# certificate

output "certificate_id" {
  value = module.eks.certificate_id
}

output "certificate_certificates" {
  value = module.eks.certificate_certificates
}

# iam_openid_connect_provider

output "iam_openid_connect_provider_arn" {
  value = module.eks.iam_openid_connect_provider_arn
}

output "iam_openid_connect_provider_tags_all" {
  value = module.eks.iam_openid_connect_provider_tags_all
}


output "iam_openid_connect_provider_thumbprint_list" {
  value = module.eks.iam_openid_connect_provider_thumbprint_list
}

output "iam_openid_connect_provider_id" {
  value = module.eks.iam_openid_connect_provider_id
}

# eks_addon

output "eks_addon_arn_map" {
  value = module.eks.eks_addon_arn_map
}

output "eks_addon_created_at_map" {
  value = module.eks.eks_addon_created_at_map
}

output "eks_addon_modified_at_map" {
  value = module.eks.eks_addon_modified_at_map
}

output "eks_addon_tags_all_map" {
  value = module.eks.eks_addon_tags_all_map
}

output "eks_addon_addon_version_map" {
  value = module.eks.eks_addon_addon_version_map
}

output "eks_addon_configuration_values_map" {
  value = module.eks.eks_addon_configuration_values_map
}

output "eks_addon_id_map" {
  value = module.eks.eks_addon_id_map
}

# eks_node_group

output "eks_node_group_ami_type_map" {
  value = module.eks.eks_node_group_ami_type_map
}

output "eks_node_group_arn_map" {
  value = module.eks.eks_node_group_arn_map
}

output "eks_node_group_capacity_type_map" {
  value = module.eks.eks_node_group_capacity_type_map
}

output "eks_node_group_disk_size_map" {
  value = module.eks.eks_node_group_disk_size_map
}

output "eks_node_group_instance_types_map" {
  value = module.eks.eks_node_group_instance_types_map
}

output "eks_node_group_launch_template_map" {
  value = module.eks.eks_node_group_launch_template_map
}

output "eks_node_group_node_group_name_map" {
  value = module.eks.eks_node_group_node_group_name_map
}

output "eks_node_group_node_group_name_prefix_map" {
  value = module.eks.eks_node_group_node_group_name_prefix_map
}

output "eks_node_group_release_version_map" {
  value = module.eks.eks_node_group_release_version_map
}

output "eks_node_group_resources_map" {
  value = module.eks.eks_node_group_resources_map
}

output "eks_node_group_status_map" {
  value = module.eks.eks_node_group_status_map
}

output "eks_node_group_tags_all_map" {
  value = module.eks.eks_node_group_tags_all_map
}

output "eks_node_group_update_config_map" {
  value = module.eks.eks_node_group_update_config_map
}

output "eks_node_group_version_map" {
  value = module.eks.eks_node_group_version_map
}

output "eks_node_group_id_map" {
  value = module.eks.eks_node_group_id_map
}

# launch_template

output "launch_template_arn_map" {
  value = module.eks.launch_template_arn_map
}

output "launch_template_block_device_mappings_map" {
  value = module.eks.launch_template_block_device_mappings_map
}

output "launch_template_default_version_map" {
  value = module.eks.launch_template_default_version_map
}

output "launch_template_instance_market_options_map" {
  value = module.eks.launch_template_instance_market_options_map
}

output "launch_template_latest_version_map" {
  value = module.eks.launch_template_latest_version_map
}

output "launch_template_metadata_options_map" {
  value = module.eks.launch_template_metadata_options_map
}

output "launch_template_name_map" {
  value = module.eks.launch_template_name_map
}

output "launch_template_name_prefix_map" {
  value = module.eks.launch_template_name_prefix_map
}

output "launch_template_tags_all_map" {
  value = module.eks.launch_template_tags_all_map
}


output "launch_template_image_id_map" {
  value = module.eks.launch_template_image_id_map
}


output "launch_template_user_data_map" {
  value = module.eks.launch_template_user_data_map
}


output "launch_template_tag_specifications_map" {
  value = module.eks.launch_template_tag_specifications_map
}


output "launch_template_vpc_security_group_ids_map" {
  value = module.eks.launch_template_vpc_security_group_ids_map
}

output "launch_template_id_map" {
  value = module.eks.launch_template_id_map
}

# ami

output "ami_architecture_map" {
  value = module.eks.ami_architecture_map
}

output "ami_arn_map" {
  value = module.eks.ami_arn_map
}

output "ami_block_device_mappings_map" {
  value = module.eks.ami_block_device_mappings_map
}

output "ami_boot_mode_map" {
  value = module.eks.ami_boot_mode_map
}

output "ami_creation_date_map" {
  value = module.eks.ami_creation_date_map
}

output "ami_deprecation_time_map" {
  value = module.eks.ami_deprecation_time_map
}

output "ami_ena_support_map" {
  value = module.eks.ami_ena_support_map
}

output "ami_hypervisor_map" {
  value = module.eks.ami_hypervisor_map
}

output "ami_image_id_map" {
  value = module.eks.ami_image_id_map
}

output "ami_image_location_map" {
  value = module.eks.ami_image_location_map
}

output "ami_image_owner_alias_map" {
  value = module.eks.ami_image_owner_alias_map
}

output "ami_image_type_map" {
  value = module.eks.ami_image_type_map
}

output "ami_imds_support_map" {
  value = module.eks.ami_imds_support_map
}

output "ami_kernel_id_map" {
  value = module.eks.ami_kernel_id_map
}

output "ami_name_map" {
  value = module.eks.ami_name_map
}

output "ami_owner_id_map" {
  value = module.eks.ami_owner_id_map
}

output "ami_platform_map" {
  value = module.eks.ami_platform_map
}

output "ami_platform_details_map" {
  value = module.eks.ami_platform_details_map
}

output "ami_product_codes_map" {
  value = module.eks.ami_product_codes_map
}

output "ami_public_map" {
  value = module.eks.ami_public_map
}

output "ami_ramdisk_id_map" {
  value = module.eks.ami_ramdisk_id_map
}

output "ami_root_device_name_map" {
  value = module.eks.ami_root_device_name_map
}

output "ami_root_device_type_map" {
  value = module.eks.ami_root_device_type_map
}

output "ami_root_snapshot_id_map" {
  value = module.eks.ami_root_snapshot_id_map
}

output "ami_sriov_net_support_map" {
  value = module.eks.ami_sriov_net_support_map
}

output "ami_state_map" {
  value = module.eks.ami_state_map
}

output "ami_state_reason_map" {
  value = module.eks.ami_state_reason_map
}

output "ami_tags_map" {
  value = module.eks.ami_tags_map
}

output "ami_tpm_support_map" {
  value = module.eks.ami_tpm_support_map
}

output "ami_usage_operation_map" {
  value = module.eks.ami_usage_operation_map
}

output "ami_virtualization_type_map" {
  value = module.eks.ami_virtualization_type_map
}

output "ami_id_map" {
  value = module.eks.ami_id_map
}
