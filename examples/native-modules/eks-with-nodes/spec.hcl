node aws_eks_cluster main {}

node aws_eks_addon main {
  plural = true

  attributes {
    cluster_name = aws_eks_cluster.main.id
    addon_name   = plural.key
  }

  meta {
    depends_on = [aws_iam_openid_connect_provider.main]
  }
}

node tls_certificate main {
  readonly = true

  attributes {
    url = aws_eks_cluster.main.identity[0].oidc[0].issuer
  }
}

# node tls_certificate main {
#   readonly = true

#   attributes {
#     url = aws_eks_cluster.main.identity[0].oidc[0].issuer
#   }
# }


node aws_iam_openid_connect_provider main {
  attributes {
    url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = [tls_certificate.main.certificates[0].sha1_fingerprint]
  }
}

node aws_launch_template main {
  predicate = length(
    regexall(
      "bootstrap\\.sh.+[\\\"\\'\\s]${aws_eks_cluster.main.id}[\\\"\\']?\\s*$",
      base64decode(predicate_attr.user_data)
    )
  ) > 0
}

node aws_eks_node_group main {
  attributes {
    cluster_name = aws_eks_cluster.main.id
    launch_template {
      name = aws_launch_template.main.name
    }
  }
}
