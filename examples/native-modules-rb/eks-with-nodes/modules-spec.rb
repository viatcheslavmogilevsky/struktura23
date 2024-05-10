require 'struktura23'

class EksWithNodes < Struktura23::BaseSpec
  provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  provider :opentofu, :http, source: "hashicorp/tls", version: ">= 4.0.4"
  query_provider :aws, :core_sdk_wrapper


  has_wrapper :launch_template do |m|
    m.required_core_type :aws_launch_template

    m.has_many :aws_ami do |ami, _|
      ami.data_source true
      ami.allowed_ids ["enabled"]
    end

    m.core.enforce :image_id do |context|
      "#{context.core.var[:image_id]} ? #{context.core.var[:image_id]} : #{context.aws_ami["enabled"].value[:image_id]}"
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

      m.has_many :aws_iam_openid_connect_provider do |providers, root|
        providers.where url: root.core.found.identity[0].oidc[0].issuer
        providers.allowed_ids ["enabled"]
        providers.identify {|_| "enabled"}
      end

      m.has_many :aws_eks_addon do |addons, root|
        addons.where cluster_name: root.core.found.id
        addons.identify {|found_addon| found_addon.name}
      end

      m.has_many :aws_eks_node_group do |groups, root|
        groups.where cluster_name: root.core.found.id
        groups.identify {|found_group| found_group.node_group_name}
        # groups.enforce :"launch_template.name"  => Struktura23::Utils.expression(:"???"), :"launch_template.version" => :"???"
        groups.add_var {:common_launch_template_key => "string"}

        groups.enforce :"launch_template.name" do |context|
          "???"
        end

        groups.enforce :"launch_template.version" do |context|
          "???"
        end
      end

      m.has_many :aws_launch_template, :common_launch_template do |lt, _|
        lt.wrap :launch_template
        lt.where false
      end

      m.has_many :aws_launch_template, :ng_launch_template do |lt, _|
        lt.wrap :launch_template
        lt.where false
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

