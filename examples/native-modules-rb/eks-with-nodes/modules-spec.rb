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
    providers.keys {|_| "enabled"}

    providers.where {
      :url => root.identity[0].oidc[0].issuer,
      # :client_id_list => ["sts.amazonaws.com"],
      # :thumbprint_list => [tls_certificate.call().certificates[0].sha1_fingerprint]
    }
  end

  cluster.has_many :aws_eks_addon do |addons, root|
    addons.where cluster_name: root.id
    addons.keys {|addon| addon.name}
  end

  templates = cluster.has_many :aws_launch_template do |lt, root|
    lt.keys {|template| template.name}
    lt.where_true do |template|
      /bootstrap\.sh.+[\"\'\s]#{root.id}[\"\'\s]\s*$/ =~ ModuleSpec::Utils.base64decode(template.user_data)
    end
  end

  templates.each do |template|
    template.has_many :aws_eks_node_group do |groups, root|
      groups.keys {|group| group.node_group_name}
      groups.where {
        :cluster_name => cluster.id,
        :"launch_template.name" => root.name
      }
    end
  end
end



EksWithNodes.scan







# export for enforcing feature???











