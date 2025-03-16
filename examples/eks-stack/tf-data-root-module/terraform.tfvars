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
  "_common" = {
    "node_role_arn" = "abc123"
  },
  "main" = {
    launch_template = {
      launch_template_key = "main"
    }
  }
  "extra" = {
    use_key_as = "node_group_name_prefix"
    launch_template = {
      name = "additional"
      version = "10"
    }
  }
}