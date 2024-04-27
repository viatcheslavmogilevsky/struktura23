require 'strucktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :core_sdk_wrapper

  cluster = has_one :aws_eks_cluster

  # but also be specified as
  # cluster = self.is_one :aws_eks_cluster, :cluster

  cluster.has_one :tls_certificate do |cert, root|
    cert.data_source true
    cert.where url: root.identity[0].oidc[0].issuer
  end

  cluster.has_many :aws_iam_openid_connect_provider do |providers, root|
    providers.where {
      :url => root.identity[0].oidc[0].issuer,
    }

    providers.max_count 1
    providers.import_to_key {|_| "enabled"}
  end

  cluster.has_many :aws_eks_addon do |addons, root|
    addons.where cluster_name: root.id
    addons.import_to_key {|addon| addon.name}
  end

  # We have some misunderstanding here: begin
  eks_node_groups = cluster.has_many :aws_eks_node_group do |groups, root|
    groups.where {
      :cluster_name => root.id
    }

    group_name_prefixes = ModuleSpec::Utils.short_ids(groups.found.map(&:node_group_name))
    launch_template_names = groups.found.map {|ng| ng.launch_template.name}.compact
    launch_template_name_prefixes = ModuleSpec::Utils.short_ids(launch_template_names)

    groups.import_to_key do |group|
      {
        group_name_prefixes[group.node_group_name] => {
          :launch_template = launch_template_name_prefixes[group.launch_template.name] || "none"
        }
      }
    end

    groups.instance_variable_set(@launch_template_names, launch_template_names)
    groups.instance_variable_set(@launch_template_name_prefixes, launch_template_name_prefixes)
  end

  cluster.has_many :aws_launch_template do |lt, root|
    lt.where_in {
      :name => eks_node_groups.instance_variable_get(@launch_template_names)
    }

    lt.import_to_key do |template|
      eks_node_groups.instance_variable_get(@launch_template_name_prefixes)[template.name]
    end
  end
  # We have some misunderstanding here: end
end

# then this class used in bins:
# EksWithNodes.scan

