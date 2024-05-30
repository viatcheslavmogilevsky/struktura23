load 'struktura23/base-spec.rb'

# require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_query_provider


  lt_wrapper = has_wrapper :launch_template, of: :aws_launch_template do |m, core|
    aws_ami = m.has_optional_data :aws_ami

    core.enforce :image_id do |context|
      "#{aws_ami.flag_to_enable} ? #{aws_ami.one.image_id} : #{context.current_var}"
    end
  end

  has_many :aws_eks_cluster do |eks_clusters|
    eks_clusters.identify {|found_cluster| found_cluster.id }
    eks_clusters.wrap do |m|
      m.has_one_data :tls_certificate do |cert, core|
        cert.where url: core.found.identity[0].oidc[0].issuer
        cert.disable_input
        cert.disable_output
      end

      m.has_optional :aws_iam_openid_connect_provider do |connect_provider, core|
        connect_provider.where url: core.found.identity[0].oidc[0].issuer
      end

      m.has_many :aws_eks_addon do |addons, core|
        addons.where cluster_name: core.found.id
        addons.identify {|found_addon| found_addon.name}
      end

      common_launch_templates = m.has_many :aws_launch_template, :common_launch_template do |lt|
        lt.wrap_by lt_wrapper
        lt.where false
      end

      custom_launch_templates = m.has_many :aws_launch_template, :custom_launch_template do |lt|
        lt.wrap_by lt_wrapper
        lt.where false
        lt.disable_input
        lt.override_for_each do |context|
          ng = context.wrapper.aws_eks_node_group
          clt = ng.var[:custom_launch_template]
          "{for input_key in #{ng} : input_key => #{clt} if #{clt} != null}"
        end
      end

      m.has_many :aws_eks_node_group do |groups, core|
        groups.where cluster_name: core.found.id
        groups.identify {|found_group| found_group.node_group_name}

        groups.add_var common_launch_template_key: "string"
        groups.add_var custom_launch_template: lt_wrapper

        groups.enforce :launch_template do |context|
          custom_launch_template = custom_launch_templates.at(context.current.key)
          common_launch_template = common_launch_templates.at(context.current.var[:common_launch_template_key])

          {
            :name => "#{context.current.var[:custom_launch_template]} != null ? "\
              "#{custom_launch_template.name} : "\
              "(#{context.current.var[:common_launch_template_key]} != null ? #{common_launch_template.name} : #{context.current_var})",
            # TODO: latest_version/default_version
            :version => "#{context.current.var[:custom_launch_template]} != null ? "\
              "#{custom_launch_template.latest_version} : "\
              "(#{context.current.var[:common_launch_template_key]} != null ? #{common_launch_template.latest_version} : #{context.current_var})"
          }
        end
      end
    end
  end

  has_many :aws_launch_template, :launch_template do |templates|
    templates.identify {|found_template| found_template.name}
    templates.wrap_by lt_wrapper
  end
end

# then this class used in bins:
# EksWithNodes.generate_opentofu_modules
# EksWithNodes.scan

