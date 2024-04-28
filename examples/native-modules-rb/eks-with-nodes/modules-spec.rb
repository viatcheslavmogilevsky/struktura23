require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_wrapper

  eks_cores = opentofu_modules :eks_core
  compute_templates = opentofu_modules :compute_template

  # cluster = eks_cores.every.has_one :aws_eks_cluster
  # launch_template = compute_templates.every.has_one :aws_launch_template
  # launch_template.mark_ownership_by_default = false

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

    # cluster.has_many :aws_launch_template do |templates, root|
    #   templates.where false
    #   # templates.import_to_key do |template, owner|
    #   #   template.ownership_reference do |ownership|
    #   #     ownership[:cluster] ||= {}
    #   #     ownership[:cluster][owner.id] = true
    #   #   end
    #   #   template.name
    #   # end
    # end

    eks_node_groups = cluster.has_many :aws_eks_node_group do |groups, root|
      groups.where cluster_name: root.id
      groups.import_to_key {|group| group.node_group_name}
    end

    # eks_node_groups.each do  .has_many :aws_launch_template do |launch_templates, root|
    #   launch_templates.max_count 1

    #   template_name = root&.launch_template&.name
    #   launch_templates.where false
    #   if template_name
    #     launch_templates.where name: template_name
    #   end

    #   launch_templates.import_to_key {|_| "launch_template"}
    # end

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
    # launch_template.takeable true
    # compute_template.has_one :aws_launch_template do |launch_template, root|
    #   root.import_to_key do |launch_template|

    #     # key_to_import = launch_template.name
    #     # launch_template.ownership_reference do |ownership|
    #     #   ownership[:opentofu_module] ||= {}
    #     #   ownership[:opentofu_module][key_to_import] = true
    #     # end
    #     # key_to_import
    #   end
    # end
  end




  # # We have some misunderstanding here: begin
  # eks_node_groups = cluster.has_many :aws_eks_node_group do |groups, root|
  #   groups.where {
  #     :cluster_name => root.id
  #   }

  #   group_name_prefixes = ModuleSpec::Utils.short_ids(groups.found.map(&:node_group_name))
  #   launch_template_names = groups.found.map {|ng| ng.launch_template.name}.compact
  #   launch_template_name_prefixes = ModuleSpec::Utils.short_ids(launch_template_names)

  #   groups.import_to_key do |group|
  #     {
  #       group_name_prefixes[group.node_group_name] => {
  #         :launch_template = launch_template_name_prefixes[group.launch_template.name] || "none"
  #       }
  #     }
  #   end

  #   groups.instance_variable_set(@launch_template_names, launch_template_names)
  #   groups.instance_variable_set(@launch_template_name_prefixes, launch_template_name_prefixes)
  # end

  # cluster.has_many :aws_launch_template do |lt, root|
  #   lt.where_in {
  #     :name => eks_node_groups.instance_variable_get(@launch_template_names)
  #   }

  #   lt.import_to_key do |template|
  #     eks_node_groups.instance_variable_get(@launch_template_name_prefixes)[template.name]
  #   end
  # end
  # # We have some misunderstanding here: end
end

# then this class used in bins:
# EksWithNodes.scan

