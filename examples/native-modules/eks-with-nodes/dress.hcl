dress aws_eks_cluster main {
  version = "1.27"
}

dress_keys aws_eks_addon main {
  set = toset(["vpc-cni", "kube-proxy", "coredns"])
}

dress aws_eks_addon main {
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

