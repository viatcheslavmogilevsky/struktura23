has_one aws_eks_cluster main {}

has_many aws_eks_addon main {
  where {
    cluster_name = aws_eks_cluster.main.id
  }

  meta {
    depends_on = [aws_iam_openid_connect_provider.main]
  }

  id = this.addon_name
}

has_one tls_certificate main {
  readonly = true
  where {
    url = aws_eks_cluster.main.identity[0].oidc[0].issuer
  }
}

has_one aws_iam_openid_connect_provider main {
  where {
    url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = [tls_certificate.main.certificates[0].sha1_fingerprint]
  }
}

has_many aws_launch_template main {
  where_true = [
    length(
      regexall(
        "bootstrap\\.sh.+[\\\"\\'\\s]${aws_eks_cluster.main.id}[\\\"\\']?\\s*$",
        base64decode(this.user_data)
      )
    ) > 0
  ]

  for_each_key = this.placement.availability_zone
}

has_many aws_eks_node_group main {
  where {
    cluster_name = aws_eks_cluster.main.id
  }

  where_has_one = {
    launch_template = [for lt in aws_launch_template.main : lt if lt.name = this.launch_template.name]
  }

  for_each_key = "${for_each_key_of(this.where_has_one.launch_template[0])}-${this.capacity_type}"
}

