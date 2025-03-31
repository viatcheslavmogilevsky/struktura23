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
  value = one([for elem in aws_iam_openid_connect_provider.this : lookup(elem, "id", null)])
}

# eks_addon

output "eks_addon_arn_map" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].arn if v.enabled && k != "_common" }
}

output "eks_addon_created_at_map" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].created_at if v.enabled && k != "_common" }
}

output "eks_addon_modified_at_map" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].modified_at if v.enabled && k != "_common" }
}

output "eks_addon_tags_all_map" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].tags_all if v.enabled && k != "_common" }
}

output "eks_addon_addon_version_map" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].addon_version if v.enabled && k != "_common" }
}

output "eks_addon_configuration_values_map" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].configuration_values if v.enabled && k != "_common" }
}

output "eks_addon_id_map" {
  value = { for k, v in var.eks_addons : k => lookup(aws_eks_addon.this[k], "id", null) if v.enabled && k != "_common" }
}

# eks_node_group

output "eks_node_group_ami_type_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].ami_type if v.enabled && k != "_common" }
}

output "eks_node_group_arn_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].arn if v.enabled && k != "_common" }
}

output "eks_node_group_capacity_type_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].capacity_type if v.enabled && k != "_common" }
}

output "eks_node_group_disk_size_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].disk_size if v.enabled && k != "_common" }
}

output "eks_node_group_instance_types_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].instance_types if v.enabled && k != "_common" }
}

output "eks_node_group_launch_template_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].launch_template if v.enabled && k != "_common" }
}

output "eks_node_group_node_group_name_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].node_group_name if v.enabled && k != "_common" }
}

output "eks_node_group_node_group_name_prefix_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].node_group_name_prefix if v.enabled && k != "_common" }
}

output "eks_node_group_release_version_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].release_version if v.enabled && k != "_common" }
}

output "eks_node_group_resources_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].resources if v.enabled && k != "_common" }
}

output "eks_node_group_status_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].status if v.enabled && k != "_common" }
}

output "eks_node_group_tags_all_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].tags_all if v.enabled && k != "_common" }
}

output "eks_node_group_update_config_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].update_config if v.enabled && k != "_common" }
}

output "eks_node_group_version_map" {
  value = { for k, v in var.eks_node_groups : k => aws_eks_node_group.this[k].version if v.enabled && k != "_common" }
}

output "eks_node_group_id_map" {
  value = { for k, v in var.eks_node_groups : k => lookup(aws_eks_node_group.this[k], "id", null) if v.enabled && k != "_common" }
}

# launch_template

output "launch_template_arn_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].arn if v.enabled && k != "_common" }
}

output "launch_template_block_device_mappings_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].block_device_mappings if v.enabled && k != "_common" }
}

output "launch_template_default_version_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].default_version if v.enabled && k != "_common" }
}

output "launch_template_instance_market_options_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].instance_market_options if v.enabled && k != "_common" }
}

output "launch_template_latest_version_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].latest_version if v.enabled && k != "_common" }
}

output "launch_template_metadata_options_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].metadata_options if v.enabled && k != "_common" }
}

output "launch_template_name_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].name if v.enabled && k != "_common" }
}

output "launch_template_name_prefix_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].name_prefix if v.enabled && k != "_common" }
}

output "launch_template_tags_all_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].tags_all if v.enabled && k != "_common" }
}

## because it's enforced:
output "launch_template_image_id_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].image_id if v.enabled && k != "_common" }
}

## because it's enforced:
output "launch_template_user_data_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].user_data if v.enabled && k != "_common" }
}

## because it's enforced:
output "launch_template_tag_specifications_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].tag_specifications if v.enabled && k != "_common" }
}

## because it's enforced:
output "launch_template_vpc_security_group_ids_map" {
  value = { for k, v in var.launch_templates : k => aws_launch_template.this[k].vpc_security_group_ids if v.enabled && k != "_common" }
}

output "launch_template_id_map" {
  value = { for k, v in var.launch_templates : k => lookup(aws_launch_template.this[k], "id", null) if v.enabled && k != "_common" }
}

# ami

output "ami_architecture_map" {
  value = { for k, v in local.merged_no_key_attrs["launch_templates"] : k =>  data.aws_ami.this[k].architecture if v.ami != null }
}

# TBD
