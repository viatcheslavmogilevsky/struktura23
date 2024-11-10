# eks_cluster

output "eks_cluster_vpc_config" {
  value = one(aws_eks_cluster.this.vpc_config[*])
}

output "eks_cluster_access_config" {
  value = one(aws_eks_cluster.this.access_config[*])
}

output "eks_cluster_encryption_config" {
  value = one(aws_eks_cluster.this.encryption_config[*])
}

output "eks_cluster_kubernetes_network_config" {
  value = one(aws_eks_cluster.this.kubernetes_network_config[*])
}

output "eks_cluster_outpost_config" {
  value = one(aws_eks_cluster.this.outpost_config[*])
}

output "eks_cluster_upgrade_policy" {
  value = one(aws_eks_cluster.this.upgrade_policy[*])
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

output "eks_cluster_id" {
  value = aws_eks_cluster.this.id
}

output "eks_cluster_identity" {
  value = one(aws_eks_cluster.this.identity[*])
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

# certificate

output "certificate_id" {
  value = one(data.tls_certificate.this[*].id)
}

output "certificate_certificates" {
  value = one(data.tls_certificate.this[*].certificates)
}

# iam_openid_connect_provider

output "iam_openid_connect_provider_thumbprint_list" {
  value = one(aws_iam_openid_connect_provider.this[*].thumbprint_list)
}

output "iam_openid_connect_provider_arn" {
  value = one(aws_iam_openid_connect_provider.this[*].arn)
}

output "iam_openid_connect_provider_tags_all" {
  value = one(aws_iam_openid_connect_provider.this[*].tags_all)
}

# eks_addon

output "eks_addon_arn_mapping" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].arn if v.enabled }
}

output "eks_addon_id_mapping" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].id if v.enabled }
}

output "eks_addon_created_at_mapping" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].created_at if v.enabled }
}

output "eks_addon_modified_at_mapping" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].modified_at if v.enabled }
}

output "eks_addon_tags_all_mapping" {
  value = { for k, v in var.eks_addons : k => aws_eks_addon.this[k].tags_all if v.enabled }
}
