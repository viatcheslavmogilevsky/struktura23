require 'module-spec'

class EksWithNodes < ModuleSpec::Base
  cluster = self.has_one :aws_eks_cluster

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

  eks_node_groups = cluster.has_many :aws_eks_node_group do |groups, root|
    groups.where {
      :cluster_name => root.id
    }

    group_name_prefixes = ModuleSpec::Utils.short_ids(groups.found.map(&:node_group_name))
    launch_template_name_prefixes = ModuleSpec::Utils.short_ids(groups.found.map {|ng| ng.launch_template.name})

    groups.import_to_key do |group, found_groups|
      {
        group_name_prefixes[group.node_group_name] => {
          :launch_template_name = launch_template_name_prefixes[group.launch_template.name]
        }
      }
    end
  end

  cluster.has_many :aws_launch_template do |lt, root|
    lt.where_in {
      :name => eks_node_groups.found.map {|ng| ng.launch_template.name}
    }

    launch_template_name_prefixes = ModuleSpec::Utils.short_ids(lt.found.map(&:name))

    lt.import_to_key do |template, found_templates|
      launch_template_name_prefixes[template.name]
    end
  end
end

# then this class used in bins:
# EksWithNodes.scan

