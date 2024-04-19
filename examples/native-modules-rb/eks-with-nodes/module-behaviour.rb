EksWithNodes.behave do |config|
  config.aws_eks_cluster do |cluster|
    cluster.defaults {
      :version => "1.27"
    }
  end

  config.aws_eks_addon do |addons|
    addons.default_keys = ["vpc-cni", "kube-proxy", "coredns"]

    addons.defaults {
      :resolve_conflicts_on_create => "OVERWRITE",
      :resolve_conflicts_on_update => "OVERWRITE"
    }

    addons.enforce {
      :depends_on => [config.aws_iam_openid_connect_provider().resource_ref]
    }
  end

  config.aws_iam_openid_connect_provider do |providers|
    providers.enforce_keys do
      irsa_addons = ["vpc-cni", "aws-ebs-csi-driver"]

      if (config.aws_eks_addon().found_keys & irsa_addons).any?
        ["enabled"]
      else
        config.aws_iam_openid_connect_provider().found_keys
      end
    end

    providers.enforce {
      :client_id_list => ["sts.amazonaws.com"],
      :thumbprint_list => [config.tls_certificate(:"certificates.0.sha1_fingerprint")]
    }
  end
end