load 'struktura23/base-spec.rb'

# require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  add_provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  add_provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  add_query_provider :aws, :core_sdk_query_provider


  lt_wrapper = has_wrapper :launch_template, of: :aws_launch_template do |m, core|
    aws_ami = m.has_optional_data :aws_ami

    core.enforce :image_id do |context|
      context.expr "%{is_data_enabled} ? %{image_from_data} : %{default}", {
        is_data_enabled: aws_ami.flag_to_enable,
        image_from_data: aws_ami.one.image_id,
        default: context.current_var
      }
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

      m.has_many :aws_eks_node_group do |groups, core|
        groups.where cluster_name: core.found.id
        groups.identify {|found_group| found_group.node_group_name}
        groups.add_var common_launch_template_key: "string"

        groups.enforce :launch_template do |context|
          common_launch_template_key = context.current.var[:common_launch_template_key]
          common_launch_template = common_launch_templates.at(common_launch_template_key)

          {
            :name => context.expr("%{common} != null ? %{common_name} : %{default}", {
              :common => common_launch_template_key,
              :common_name => common_launch_template.name,
              :default => context.current_var.name
            }),
            :version => context.expr("%{common} != null ? %{common_version} : %{default}", {
              :common => common_launch_template_key,
              :common_version => common_launch_template.latest_version,
              :default => context.current_var.version
            })
          }
        end

        groups.wrap do |ngm|
          template = ngm.has_optional :aws_launch_template do |lt|
            lt.wrap_by lt_wrapper
            lt.where false
          end

          ngm.core.enforce :launch_template do |context|
            {
              :name => context.expr("%{custom_enabled}  ? %{custom_name} : %{default}", {
                :custom_enabled => template.flag_to_enable,
                :custom_name => template.one.name,
                :default => context.current_var.name
              }),
              :version => context.expr("%{custom_enabled}  ? %{custom_version} : %{default}", {
                :custom_enabled => template.flag_to_enable,
                :custom_version => template.one.latest_version,
                :default => context.current_var.version
              })
            }
          end
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
# EksWithNodes.to_opentofu
# EksWithNodes.scan

