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

output "iam_openid_connect_provider_thumbprint_list" {
  value = module.eks.iam_openid_connect_provider_thumbprint_list
}

output "iam_openid_connect_provider_arn" {
  value = module.eks.iam_openid_connect_provider_arn
}

output "iam_openid_connect_provider_tags_all" {
  value = module.eks.iam_openid_connect_provider_tags_all
}

output "iam_openid_connect_provider_id" {
  value = module.eks.iam_openid_connect_provider_id
}

# eks_addon

output "eks_addon_arn_map" {
  value = module.eks.eks_addon_arn_map
}

output "eks_addon_id_map" {
  value = module.eks.eks_addon_id_map
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
