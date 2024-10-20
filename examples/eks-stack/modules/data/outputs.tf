output "partition" {
  value = data.aws_partition.this.partition
}

output "availability_zone_names" {
  value = data.aws_availability_zones.this.names
}

output "region_name" {
  value = data.aws_region.this.name
}

output "eks_cluster_assume_role_policy_json" {
  value = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

output "eks_cluster_custom_policy_json" {
  value = data.aws_iam_policy_document.eks_cluster_custom_policy.json
}

output "ec2_instance_assume_role_policy_json" {
  value = data.aws_iam_policy_document.ec2_instance_assume_role_policy.json
}

output "ec2_instance_custom_policy_json" {
  value = data.aws_iam_policy_document.ec2_instance_custom_policy.json
}
