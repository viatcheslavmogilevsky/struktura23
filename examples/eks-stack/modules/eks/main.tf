resource "aws_eks_cluster" "this" {
  name = var.eks_cluster_name


  role_arn = var.eks_role_arn

  enabled_cluster_log_types = var.eks_enabled_log_types
  version                   = var.eks_cluster_version
  tags                      = var.eks_tags

  vpc_config {
    subnet_ids              = var.eks_subnet_ids
    endpoint_private_access = var.eks_endpoint_private_access
    endpoint_public_access  = var.eks_endpoint_public_access
    public_access_cidrs     = var.eks_public_access_cidrs
    security_group_ids      = var.eks_security_group_ids
  }
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
}

resource "aws_eks_addon" "this" {
  for_each          = toset(["vpc-cni","kube-proxy","coredns"])
  cluster_name      = aws_eks_cluster.this.id
  addon_name        = each.key
  resolve_conflicts = "OVERWRITE"

  depends_on = [
    aws_iam_openid_connect_provider.this,
  ]
}
