require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_wrapper

  eks_cores = opentofu_modules :eks_core
  compute_templates = opentofu_modules :compute_template

  eks_cores.def_each do |eks_core|
    cluster = eks_core.has_one :cluster

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
        templates.claim_with cluster_name: root.cluster_name, node_group_name: root.node_group_name, template_name: :name
      end
    end

    cluster.found.id
  end

  compute_templates.def_each do |compute_template|
    launch_template = compute_template.has_one :aws_launch_template

    launch_template.has_one :aws_ami do |ami, root|
      ami.data_source true
      ami.where {
        :"filter.0.image-id" => [root.image_id]
      }
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
      # https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
    end

    launch_template.found.name
  end
end
# then this class used in bins:
# EksWithNodes.scan

