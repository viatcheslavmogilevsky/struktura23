require 'spec_helper'

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


describe EksWithNodes do
  before :each do
    @opentofu = EksWithNodes.to_opentofu
    @data_aws_ami_schema = EksWithNodes.schemas.select do |s|
      s.name == :aws_ami && s.group_name == :data
    end.first
    @resource_aws_launch_template_schema = EksWithNodes.schemas.select do |s|
      s.name == :aws_launch_template && s.group_name == :resource
    end.first
  end

  it 'generates some opentofu' do
    expect(@opentofu).to be_a(Hash)
  end

  it 'generates non-empty variables' do
    expect(@opentofu["variables"]).to have_attributes(size: (be > 0))
    expect(@opentofu["variables"].keys).to include(
      *@data_aws_ami_schema.input_definition.keys.map {|k| "aws_eks_cluster_main_aws_launch_template_common_launch_template_aws_ami_main_#{k}"}
    )
    expect(@opentofu["variables"].keys).to include(
      *@data_aws_ami_schema.input_definition.keys.map {|k| "aws_eks_cluster_main_aws_eks_node_group_main_aws_launch_template_main_aws_ami_main_#{k}"}
    )
    expect(@opentofu["variables"].keys).to include(
      *@data_aws_ami_schema.input_definition.keys.map {|k| "aws_launch_template_launch_template_aws_ami_main_#{k}"}
    )
    expect(@opentofu["variables"].keys).to include(
      *@resource_aws_launch_template_schema.input_definition.keys.map {|k| "aws_launch_template_launch_template_#{k}"}
    )
    expect(@opentofu["variables"].keys).to include(
      *@resource_aws_launch_template_schema.input_definition.keys.map {|k| "aws_eks_cluster_main_aws_launch_template_common_launch_template_#{k}"}
    )
    expect(@opentofu["variables"].keys).to include(
      *@resource_aws_launch_template_schema.input_definition.keys.map {|k| "aws_eks_cluster_main_aws_eks_node_group_main_aws_launch_template_main_#{k}"}
    )
    expect(@opentofu["variables"].keys).to include(
      "aws_eks_cluster_main_enable_aws_iam_openid_connect_provider_main",
      "aws_eks_cluster_main_aws_eks_node_group_main_enable_aws_launch_template_main",
      "aws_launch_template_launch_template_enable_aws_ami_main"
    )
  end

  it 'generates empty resource' do
    expect(@opentofu["resource"]).to eq({})
  end

  it 'generates empty datasource' do
    expect(@opentofu["data"]).to eq({})
  end

  it 'generates non-empty module' do
    expect(@opentofu["module"]).to have_attributes(size: (be > 0))
    expect(@opentofu["module"]["aws_eks_cluster_main"]).to have_attributes(size: (be > 0))
    expect(@opentofu["module"]["aws_launch_template_launch_template"]).to have_attributes(size: (be > 0))
    expect(@opentofu["module"]["aws_eks_cluster_main"].keys).to include(
      *@resource_aws_launch_template_schema.input_definition.keys.map {|k| "aws_launch_template_common_launch_template_#{k}"}
    )
    expect(@opentofu["module"]["aws_eks_cluster_main"].keys).to include(
      *@resource_aws_launch_template_schema.input_definition.keys.map {|k| "aws_eks_node_group_main_aws_launch_template_main_#{k}"}
    )
    expect(@opentofu["module"]["aws_eks_cluster_main"].keys).to include(
      *@data_aws_ami_schema.input_definition.keys.map {|k| "aws_launch_template_common_launch_template_aws_ami_main_#{k}"}
    )
    expect(@opentofu["module"]["aws_eks_cluster_main"].keys).to include(
      *@data_aws_ami_schema.input_definition.keys.map {|k| "aws_eks_node_group_main_aws_launch_template_main_aws_ami_main_#{k}"}
    )
    expect(@opentofu["module"]["aws_eks_cluster_main"].keys).to include(
      "aws_launch_template_common_launch_template_enable_aws_ami_main",
      "aws_eks_node_group_main_aws_launch_template_main_enable_aws_ami_main"
    )
  end

  it 'generates non-empty module contents' do
    expect(@opentofu["module"]["aws_eks_cluster_main"]["contents"]).to include(
      "variables", "resource", "data", "output", "module", "provider", "locals", "terraform"
    )
    expect(@opentofu["module"]["aws_launch_template_launch_template"]["contents"]).to include(
      "variables", "resource", "data", "output", "module", "provider", "locals", "terraform"
    )
  end

  it 'generates non-empty module contents variables' do
    expect(@opentofu["module"]["aws_eks_cluster_main"]["contents"]["variables"].keys).to include(
      *@resource_aws_launch_template_schema.input_definition.keys.map {|k| "aws_launch_template_common_launch_template_#{k}"}
    )
    expect(@opentofu["module"]["aws_eks_cluster_main"]["contents"]["variables"].keys).to include(
      *@resource_aws_launch_template_schema.input_definition.keys.map {|k| "aws_eks_node_group_main_aws_launch_template_main_#{k}"}
    )
    expect(@opentofu["module"]["aws_eks_cluster_main"]["contents"]["variables"].keys).to include(
      *@data_aws_ami_schema.input_definition.keys.map {|k| "aws_launch_template_common_launch_template_aws_ami_main_#{k}"}
    )
    expect(@opentofu["module"]["aws_eks_cluster_main"]["contents"]["variables"].keys).to include(
      *@data_aws_ami_schema.input_definition.keys.map {|k| "aws_eks_node_group_main_aws_launch_template_main_aws_ami_main_#{k}"}
    )

    expect(@opentofu["module"]["aws_launch_template_launch_template"]["contents"]["variables"].keys).to include(
      *@resource_aws_launch_template_schema.input_definition.keys
    )
    expect(@opentofu["module"]["aws_launch_template_launch_template"]["contents"]["variables"].keys).to include(
      *@data_aws_ami_schema.input_definition.keys.map {|k| "aws_ami_main_#{k}"}
    )
  end

  it 'generates non-empty module contents resource' do
    expect(@opentofu["module"]["aws_eks_cluster_main"]["contents"]["resource"]).to include(
      {
        :aws_iam_openid_connect_provider=>{:main=>{:tag=>"var.aws_iam_openid_connect_provider_main_tag", "count"=>"var.enable_aws_iam_openid_connect_provider_main ? 1 : 0"}},
        :aws_eks_addon=>{:main=>{:tag=>"var.aws_eks_addon_main_tag"}},
        "aws_eks_cluster"=>{"core"=>{:tag=>"var.tag"}}
      }
    )

    expect(@opentofu["module"]["aws_launch_template_launch_template"]["contents"]["resource"]["aws_launch_template"]["core"].keys).to include(
      *@resource_aws_launch_template_schema.input_definition.keys
    )
  end

  it 'generates non-empty module contents data' do
    expect(@opentofu["module"]["aws_eks_cluster_main"]["contents"]["data"]).to eq(
      {:tls_certificate=>{:main=>{}}}
    )
    expect(@opentofu["module"]["aws_launch_template_launch_template"]["contents"]["data"][:aws_ami][:main]).to include(
      Hash[@data_aws_ami_schema.input_definition.keys.map {|k| [k, "var.aws_ami_main_#{k}"]}]
    )
    expect(@opentofu["module"]["aws_launch_template_launch_template"]["contents"]["data"][:aws_ami][:main]).to include(
      {"count"=>"var.enable_aws_ami_main ? 1 : 0"}
    )
  end

  it 'generates non-empty output' do
    expect(@opentofu["output"]).to have_attributes(size: (be > 0))
    expect(@opentofu["output"].keys).to include(
      *@data_aws_ami_schema.definition.keys.map {|k| "aws_eks_cluster_main_aws_launch_template_common_launch_template_aws_ami_main_#{k}"}
    )
    expect(@opentofu["output"].keys).to include(
      *@data_aws_ami_schema.definition.keys.map {|k| "aws_eks_cluster_main_aws_eks_node_group_main_aws_launch_template_main_aws_ami_main_#{k}"}
    )
    expect(@opentofu["output"].keys).to include(
      *@data_aws_ami_schema.definition.keys.map {|k| "aws_launch_template_launch_template_aws_ami_main_#{k}"}
    )
    expect(@opentofu["output"].keys).to include(
      *@resource_aws_launch_template_schema.definition.keys.map {|k| "aws_eks_cluster_main_aws_launch_template_common_launch_template_#{k}"}
    )
  end

  # TODO: to be continued
  it 'generates empty provider/locals/terraform' do
    expect(@opentofu["provider"]).to eq({})
    expect(@opentofu["locals"]).to eq({})
    expect(@opentofu["terraform"]).to eq({})
  end
end