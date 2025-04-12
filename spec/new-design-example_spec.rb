require 'spec_helper'

class ExampleEksClusterModule < Struktura23::ModuleSpec
  require_provider(:opentofu, :aws, source: "hashicorp/aws", version: ">= 5.68.0").use_version("5.72.1")
  require_provider(:opentofu, :tls, source: "hashicorp/tls", version: ">= 4.0.6")

#   eks_cluster = module_itself.has_one(:aws_eks_cluster).identify_by(:name)
#   eks_cluster.default(enabled_cluster_log_types: ["api", "audit", "authenticator", "controllerManager", "scheduler"])
#   eks_cluster.default(bootstrap_self_managed_addons: true)
#   eks_cluster.override_block(:vpc_config).default(public_access_cidrs: ["0.0.0.0/0"])

#   connect_provider = eks_cluster.has_optional(:aws_iam_openid_connect_provider).where(url: eks_cluster.resolved.identity[0].oidc[0].issuer)
#   tls_certificate = connect_provider.has_one_data(:tls_certificate).where(url: eks_cluster.resolved.identity[0].oidc[0].issuer)
#   connect_provider.enforce(thumbprint_list: [tls_certificate.resolved.certificates[0].sha1_fingerprint])

#   eks_addons = eks_cluster.has_many(:aws_eks_addon).where(cluster_name: eks_cluster.resolved.id).identify_by(:name)
#   eks_addons.enforce(depends_on: [connect_provider.meta])

#   node_groups = eks_cluster.has_many(:aws_eks_node_group).where(cluster_name: eks_cluster.resolved.id).identify_by(:node_group_name)
#   node_groups.enforce(resolve_conflicts_on_create: "OVERWRITE")
#   node_groups.enforce(resolve_conflicts_on_update: "OVERWRITE")
#   node_groups.enforce(:lifecycle, ignore_changes: [node_groups.meta.scaling_config[0].desired_size])

#   launch_template_blk = node_groups.override_block(:launch_template)
#   launch_template = launch_template_blk.belongs_to(:aws_launch_template)
#     .where(name: launch_template_blk.resolved.name)
#     .identify_by(:name)

#   launch_template_blk.enforce(version: launch_template.resolved.latest_version)

#   ami = launch_template.has_optional_data(:aws_ami)
#   launch_template.enforce(image_id: ami.resolved.image_id)

#   launch_template.enforce(:lifecycle, ignore_changes: [launch_template.meta.tag_specifications[0].tags["Owner"]])
#   launch_template.enforce_expression({user_data: <<-USERDATA
#     base64encode(<<-EOT
#       #!/bin/bash -xe

#       # Bootstrap and join the cluster
#       /etc/eks/bootstrap.sh --b64-cluster-ca '%{cluster_cert_authority_data}' --apiserver-endpoint '%{cluster_endpoint}' '%{cluster_id}'

#       # Allow user supplied userdata code
#       echo "Node is up..."
#     EOT
#     )
# USERDATA
# }, {
#   cluster_cert_authority_data: eks_cluster.resolved.certificate_authority[0].data,
#   cluster_endpoint: eks_cluster.resolved.endpoint,
#   cluster_id: eks_cluster.resolved.id
# })

#   launch_template.enforce_expression(
#     {tag_specifications: [{resource_type: "instance", tags: {"Name"=>"%{cluster_id}-worker"}}]},
#     {cluster_id: eks_cluster.resolved.id}
#   )

#   launch_template.enforce(vpc_security_group_ids: [eks_cluster.resolved.vpc_config[0].cluster_security_group_id])
end

describe ExampleEksClusterModule do
  before :each do
    @opentofu = ExampleEksClusterModule.to_opentofu
  end

  it 'generates some opentofu' do
    expect(@opentofu).to be_a(Hash)
  end
end