eks_addons = {
  "_common" = {
    preserve = true
    tags = {
      "abc" = "def",
      "sds" = "xxx",
    }
  },
  "vpc-cni" = {
    enabled = true
  },
  "kube-proxy" = {
    tags = {
      "qwe" = "rty",
      "yui" = "nhj",
    }
  },
  "coredns" = {
    tags = {
      "ewq" = "ytr",
      "iuy" = "jhn",
    }
    customize_common = {
      "tags"     = "merge",
      "preserve" = "omit",
    }
  },
}

launch_templates = {
  "_common" = {
    monitoring = {
      enabled = true
    }
    ami = {
      most_recent = true
      name_regex  = "amazon-eks-arm64-node-1.30-v*"
      owners      = ["amazon"]
    }
  },
  "main" = {
    enabled = true
  }
}

eks_node_groups = {
  "main" = {
    node_group_name = "main"
    launch_template = {
      launch_template_key = "main"
    }
  }
}