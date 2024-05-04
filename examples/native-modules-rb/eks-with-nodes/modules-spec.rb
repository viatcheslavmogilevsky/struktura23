require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_wrapper

  # One stupid question: how to statically generate openotfofu modules
  # from following? Special 'dry_run' mode?

  clusters = has_many :aws_eks_cluster
  registry[:clusters] = clusters.map_found do |cluster|
    m = Struktura23::Utils.wrap(cluster)

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

    m.id = cluster.id
    m
  end

  launch_templates = has_many :aws_launch_template
  registry[:templates] = launch_templates.map_found do |template|
    m = Struktura23::Utils.wrap(template)

    # it is just a stub at this stage
    m.has_many :aws_ami do |ami, _|
      ami.data_source true
      ami.allowed_ids ["enabled"]
    end

    m.id = template.name
    m
  end
end

# then this class used in bins:
# EksWithNodes.scan

