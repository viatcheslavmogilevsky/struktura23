require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_wrapper


  launch_template_module = has_wrapper :launch_template do |m|
    m.has_many :aws_ami do |ami, _|
      ami.data_source true
      ami.allowed_ids ["enabled"]
    end
  end

  has_many :aws_eks_cluster do |eks_clusters|
    eks_clusters.identify {|found_cluster| found_cluster.id }
    eks_clusters.wrap(:cluster) do |m|
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

      m.has_many :aws_launch_template do |lt, _|
        lt.wrap :common_launch_template, launch_template_module
        lt.where false
      end

      m.has_many :aws_launch_template do |lt, _|
        lt.wrap :ng_launch_template, launch_template_module
        lt.where false
      end
    end
  end

  has_many :aws_launch_template do |templates|
    templates.identify {|found_template| found_template.name}
    templates.wrap :launch_template, launch_template_module
  end
end

# then this class used in bins:
# EksWithNodes.scan

