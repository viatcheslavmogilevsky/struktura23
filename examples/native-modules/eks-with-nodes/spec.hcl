one aws_eks_cluster main {}

one_or_zero aws_iam_openid_connect_provider main {
  where {
    url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = [tls_certificate.main.certificates[0].sha1_fingerprint]
  }

  force {
    let {
      irsa_addons = ["vpc-cni", "aws-ebs-csi-driver"]
      is_needed_by_addons = anytrue([for addon in ids_of(aws_eks_addon.main) : contains(let.irsa_addons, addon)])
    }

    ids = let.is_needed_by_addons ? one_ids() : ids_of(aws_iam_openid_connect_provider.main)
  }
}

many aws_eks_addon main {
  ids = attr(aws_eks_addon.main, "addon_name")

  where {
    cluster_name = aws_eks_cluster.main.id
  }

  force {
    attributes {
      depends_on = [aws_iam_openid_connect_provider.main]
    }
  }
}

one tls_certificate main {
  readonly = true
  where {
    url = aws_eks_cluster.main.identity[0].oidc[0].issuer
  }
}

many aws_launch_template main {
  ids = attr(aws_launch_template.main, "name")

  where_true = [
    length(
      regexall(
        "bootstrap\\.sh.+[\\\"\\'\\s]${aws_eks_cluster.main.id}[\\\"\\']?\\s*$",
        base64decode(aws_launch_template.main.user_data)
      )
    ) > 0
  ]
}

many aws_eks_node_group main {
  ids = attr(aws_eks_node_group.main, "node_group_name")


  belongs_to {
    launch_template = aws_launch_template.main
  }

  where {
    cluster_name = aws_eks_cluster.main.id
    launch_template {
      name = each_of.launch_template.name
    }
  }
}
