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