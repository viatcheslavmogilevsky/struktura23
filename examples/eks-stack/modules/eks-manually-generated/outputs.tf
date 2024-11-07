output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "eks_cluster_version" {
  value = aws_eks_cluster.this.version
}

output "eks_cluster_role_arn" {
  value = aws_eks_cluster.this.role_arn
}

output "eks_cluster_enabled_cluster_log_types" {
  value = aws_eks_cluster.this.enabled_cluster_log_types
}

output "eks_cluster_tags" {
  value = aws_eks_cluster.this.tags
}

output "eks_cluster_vpc_config" {
  value = one(aws_eks_cluster.this.vpc_config[*])
}

output "eks_cluster_bootstrap_self_managed_addons" {
  value = aws_eks_cluster.this.bootstrap_self_managed_addons
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
