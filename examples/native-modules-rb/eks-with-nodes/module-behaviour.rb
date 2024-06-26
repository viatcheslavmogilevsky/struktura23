# Below is totally outdated

EksWithNodes.transform do |registry|
  launch_template_refs = registry[:clusters].map do |cluster_module|
    cluster_module[:aws_eks_node_group].map do |found_node_group|
      {
        cluster_id: found_node_group.cluster_name,
        node_group_name: found_node_group.node_group_name,
        template_name: found_node_group.launch_template&.name
      }
    end
  end.flatten

  launch_template_ids = registry[:templates].map {|t| t.id}

  launch_template_ids.each do |template|
    # ???
  end

  found.configure :opentofu_modules, :eks_core

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
      :depends_on => [m.get(:aws_iam_openid_connect_provider)]
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
      :thumbprint_list => [m.get(:tls_certificate).certificates[0].sha1_fingerprint]
    }
  end

  m.configure :aws_eks_node_group do |node_groups|
    node_groups.enforce do |_, _, value|
      {
        :"launch_template.name" => m.get(:aws_launch_template)[value[:launch_template]].name
      }
    end
    node_groups.defaults do |_, _, value|
      {
        :"launch_template.version" => m.get(:aws_launch_template)[value[:launch_template]].latest_version
      }
    end
  end
end