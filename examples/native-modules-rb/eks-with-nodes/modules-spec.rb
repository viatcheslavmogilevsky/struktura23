require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_wrapper

  eks_cores = opentofu_modules :eks_core
  compute_templates = opentofu_modules :compute_template

  eks_cores.each do |eks_core|
    cluster = eks_core.has_one :cluster
    eks_core.import_to_key cluster.found.id

    cluster.has_one :tls_certificate do |cert, root|
      cert.data_source true
      cert.where url: root.identity[0].oidc[0].issuer
    end

    cluster.has_many :aws_iam_openid_connect_provider do |providers, root|
      providers.where url: root.identity[0].oidc[0].issuer

      providers.max_count 1
      providers.import_to_key {|_| "enabled"}
    end

    cluster.has_many :aws_eks_addon do |addons, root|
      addons.where cluster_name: root.id
      addons.import_to_key {|addon| addon.name}
    end

    eks_node_groups = cluster.has_many :aws_eks_node_group do |groups, root|
      groups.where cluster_name: root.id
      groups.import_to_key {|group| group.node_group_name}
    end

    eks_node_groups.each do |node_group|
      node_group.has_claims :aws_launch_template do |templates, root|
        template_name = root.launch_template&.name
        if template_name
          launch_templates.where name: template_name
        end
        templates.claim_with cluster_name: root.cluster_name, node_group_name: root.node_group_name
      end
    end
  end

  compute_templates.each do |compute_template|
    launch_template = compute_template.has_one :aws_launch_template
    compute_template.import_to_key launch_template.found.name
  end
end
# then this class used in bins:
# EksWithNodes.scan

