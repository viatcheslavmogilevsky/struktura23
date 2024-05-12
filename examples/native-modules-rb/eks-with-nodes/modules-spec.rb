require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_wrapper


  has_wrapper :launch_template, of: :aws_launch_template do |m|
    m.has_optional_one :aws_ami do |ami, _|
      ami.data_source true
    end

    m.core.enforce :image_id do |context|
      aws_ami = context.wrapper.aws_ami
      "#{aws_ami.var.length} > 0 ? #{aws_ami.enabled.image_id} : #{context.current_var} "
    end
  end

  has_many :aws_eks_cluster do |eks_clusters|
    eks_clusters.identify {|found_cluster| found_cluster.id }
    eks_clusters.wrap(:cluster) do |m|
      m.has_one :tls_certificate do |cert, root|
        cert.data_source true
        cert.where url: root.core.found.identity[0].oidc[0].issuer
        cert.enforce_all_to_default except: :url
        cert.hide_all
      end

      m.has_optional_one :aws_iam_openid_connect_provider do |connect_provider, root|
        connect_provider.where url: root.core.found.identity[0].oidc[0].issuer
      end

      m.has_many :aws_eks_addon do |addons, root|
        addons.where cluster_name: root.core.found.id
        addons.identify {|found_addon| found_addon.name}
      end

      m.has_many :aws_eks_node_group do |groups, root|
        groups.where cluster_name: root.core.found.id
        groups.identify {|found_group| found_group.node_group_name}

        groups.add_var common_launch_template_key: "string"
        groups.add_var custom_launch_template: :launch_template

        # groups.each_has_optional_one :aws_launch_template do |lt, context|
        #   lt.wrap :launch_template
        #   lt.where false
        #   lt.store context.wrapper, :custom_launch_template, context.current_key
        # end

        groups.enforce_each :"launch_template.name" do |context|
          # todo: make lambda???
          context_key = context.current_key
          custom_launch_template = context.wrapper.custom_launch_template[context_key]
          common_launch_template = context.wrapper.common_launch_template[context.current.var[:common_launch_template_key]]
          "#{context.current.var[:custom_launch_template].length} > 0 ? #{custom_launch_template.name} : (#{context.current.var[:common_launch_template_key]} != null ? #{common_launch_template.name} : #{context.current_var})"
        end

        groups.enforce_each :"launch_template.version" do |context|
          context_key = context.current_key
          custom_launch_template = context.wrapper.custom_launch_template[context_key]
          common_launch_template = context.wrapper.common_launch_template[context.current.var[:common_launch_template_key]]
          "#{context.current.var[:custom_launch_template].length} > 0 ? #{custom_launch_template.version} : (#{context.current.var[:common_launch_template_key]} != null ? #{common_launch_template.version} : #{context.current_var})"
        end
      end

      m.has_many :aws_launch_template, :common_launch_template do |lt, _|
        lt.wrap :launch_template
        lt.where false
      end

      m.has_many :aws_launch_template, :custom_launch_template do |lt, _|
        lt.wrap :launch_template
        lt.where false
        lt.enforce_each :for_each do |context|
          # "???"
        end
      end
    end
  end

  has_many :aws_launch_template, :launch_template do |templates|
    templates.identify {|found_template| found_template.name}
    templates.wrap :launch_template
  end
end

# then this class used in bins:
# EksWithNodes.scan

