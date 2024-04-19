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
    providers.max_count 1
    providers.import_to_key {|_| "enabled"}

    providers.where {
      :url => root.identity[0].oidc[0].issuer,
    }
  end

  cluster.has_many :aws_eks_addon do |addons, root|
    addons.where cluster_name: root.id
    addons.import_to_key {|addon| addon.name}
  end

  eks_node_groups = cluster.has_many :aws_eks_node_group do |groups, root|
    groups.import_to_key {|group| group.node_group_name}
    groups.where {
      :cluster_name => root.id
    }
  end

  cluster.has_many :aws_launch_template do |lt, root|
    lt.import_to_key {|template| template.name}
    lt.where_in {
      :name => eks_node_groups.resources.map {|ng| ng.launch_template.name}
    }
  end
end

# then this class used in bins:
# EksWithNodes.scan

