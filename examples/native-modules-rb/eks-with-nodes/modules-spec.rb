require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_wrapper

  clusters = has_many :aws_eks_cluster do |eks_clusters|
    eks_clusters.identify {|found_cluster| found_cluster.id }
  end

  registry[:clusters] = clusters.module_wrap do |m|
    m.has_one :tls_certificate do |cert, root|
      cert.data_source true
      cert.where url: root.identity[0].oidc[0].issuer
    end

    m.has_many :aws_iam_openid_connect_provider do |providers, root|
      providers.where url: root.identity[0].oidc[0].issuer

      providers.max_count 1
      providers.allowed_ids ["enabled"]
      providers.identify {|_| "enabled"}
    end

    m.has_many :aws_eks_addon do |addons, root|
      addons.where cluster_name: root.id
      addons.identify {|found_addon| found_addon.name}
    end

    m.has_many :aws_eks_node_group do |groups, root|
      groups.where cluster_name: root.id
      groups.identify {|found_group| found_group.node_group_name}
    end
  end

  launch_templates = has_many :aws_launch_template do |templates|
    templates.identify {|found_template| found_template.name}
  end

  registry[:templates] = launch_templates.module_wrap do |m|
    # it is just a stub at this stage
    m.has_many :aws_ami do |ami, _|
      ami.data_source true
      ami.allowed_ids ["enabled"]
    end
  end
end

# then this class used in bins:
# EksWithNodes.scan

