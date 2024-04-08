dress aws_eks_cluster main {
  attributes {
    version = "1.27"
  }
}

dress aws_eks_addon main {
  ids = toset(["vpc-cni", "kube-proxy", "coredns"])
  attributes {
    version = "1.27"
  }
}


dress aws_eks_addon main {
  attributes {
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
  }
}

