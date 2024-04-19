EksWithNodes.behave do |m|
  m.configure :aws_eks_cluster do |cluster|
    cluster.defaults {
      :version => "1.27"
    }
  end

  m.configure :aws_eks_addon do |addons|
    addons.default_keys = ["vpc-cni", "kube-proxy", "coredns"]

    addons.defaults {
      :resolve_conflicts_on_create => "OVERWRITE",
      :resolve_conflicts_on_update => "OVERWRITE"
    }

    addons.enforce {
      :depends_on => [m.get.aws_iam_openid_connect_provider]
    }
  end

  m.configure :aws_iam_openid_connect_provider do |providers|
    providers.enforce_keys do
      irsa_addons = ["vpc-cni", "aws-ebs-csi-driver"]

      if (m.found_keys_of(:aws_eks_addon) & irsa_addons).any?
        ["enabled"]
      else
        m.found_keys_of(:aws_iam_openid_connect_provider)
      end
    end

    providers.enforce {
      :client_id_list => ["sts.amazonaws.com"],
      :thumbprint_list => [m.get.tls_certificate.certificates[0].sha1_fingerprint]
    }
  end

  # this is wery sick:

  m.configure :aws_eks_node_group do |node_groups|
    node_groups.enforce do |group|
      {
        :"launch_template.name" => m.get.aws_launch_template[group.launch_template.name].name
      }
    end
  end
end