require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_wrapper

  # eks_cores = opentofu_modules :eks_core
  # compute_templates = opentofu_modules :compute_template


  clusters = has_many :aws_eks_cluster


  cluster_modules = clusters.when_found.map do |cluster|
    m = Struktura23::Utils.wrap cluster

    m.has_one :tls_certificate do |cert, root|
      cert.data_source true
      cert.where url: root.identity[0].oidc[0].issuer
    end

    m.has_many :aws_iam_openid_connect_provider do |providers, root|
      providers.where url: root.identity[0].oidc[0].issuer

      providers.max_count 1
      providers.when_found {|_| "enabled"}
    end

    m.has_many :aws_eks_addon do |addons, root|
      addons.where cluster_name: root.id
      addons.when_found {|found_addon| addon.name}
    end

    m.has_many :aws_eks_node_group do |groups, root|
      groups.where cluster_name: root.id
      groups.when_found {|found_group| found_group.node_group_name}
        # early sidenote idea:
        # [
        #   found_group.node_group_name,
        #   {node_group_name: found_group.node_group_name, template_name: found_group.launch_template&.name}
        # ]
    end

    # it is just a stub at this stage
    m.has_many :aws_launch_template do |templates|
      templates.where false
    end

    # also early idea (too noisy):
    #
    # eks_node_groups.each do |node_group|
    #   node_group.has_claims :aws_launch_template do |templates, root|
    #     template_name = root.launch_template&.name
    #     if template_name
    #       launch_templates.where name: template_name
    #     end
    #     templates.claim_with cluster_name: root.cluster_name, node_group_name: root.node_group_name, template_name: :name
    #   end
    # end

    m.id = cluster.id
    m
  end


  launch_templates = has_many :aws_launch_template

  launch_templates.when_found.map do |template|
    m = Struktura23::Utils.wrap template

    m.has_many :aws_ami do |ami, _|
      ami.data_source true
      # Since `.where` is not defined here, so it is `ami.where nil`
      # which gives zero aws_ami data sources

      # `.max_count` cannot be specified, when `.data_source true`
      # because data source returns the same value per input (`.where`) per moment
      # so `.max_count` is always 1

      # And this was sick:
      # ami.where {
      #   :"filter.0.name" => "image-id"
      #   :"filter.0.values" => [root.image_id]
      # }
    end

    m.id = template.name
    m
  end
end

# then this class used in bins:
# EksWithNodes.scan

