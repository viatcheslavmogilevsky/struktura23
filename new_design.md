# New design

## Idea

```
str23 class -> opentofu code (module)
            -> query -> opentofu code (module usage)
```


## Example

### ModuleSpec example

```rb
class ExampleEksClusterModule < Struktura23::ModuleSpec
  require_provider(:opentofu, :aws, source: "hashicorp/aws", version: ">= 5.72.1")
  require_provider(:opentofu, :tls, source: "hashicorp/tls", version: ">= 4.0.6")

  # require_provider(:opentofu, :aws, source: "hashicorp/aws", version: ">= 5.68.0").use_version("5.72.1")

  eks_cluster = module_itself.has_one(:aws_eks_cluster).identify_by(:name)
  eks_cluster.default(enabled_cluster_log_types: ["api", "audit", "authenticator", "controllerManager", "scheduler"])
  eks_cluster.default(bootstrap_self_managed_addons: true)
  eks_cluster.override_block(:vpc_config).default(public_access_cidrs: ["0.0.0.0/0"])

  connect_provider = eks_cluster.has_optional(:aws_iam_openid_connect_provider).where(url: eks_cluster.resolved.identity[0].oidc[0].issuer)
  tls_certificate = connect_provider.has_one_data(:tls_certificate).where(url: eks_cluster.resolved.identity[0].oidc[0].issuer)
  connect_provider.enforce(thumbprint_list: [tls_certificate.resolved.certificates[0].sha1_fingerprint])
 
  eks_addons = eks_cluster.has_many(:aws_eks_addon).where(cluster_name: eks_cluster.resolved.id).identify_by(:name)
  eks_addons.enforce(depends_on: [connect_provider.meta])

  node_groups = eks_cluster.has_many(:aws_eks_node_group).where(cluster_name: eks_cluster.resolved.id).identify_by(:node_group_name)
  node_groups.enforce(resolve_conflicts_on_create: "OVERWRITE")
  node_groups.enforce(resolve_conflicts_on_update: "OVERWRITE")
  node_groups.enforce(:lifecycle, ignore_changes: [node_groups.meta.scaling_config[0].desired_size])

  # _prefix attributes detected automatically, to specify behaviour use .has_prefix
  # provide block to specify how to recover prefix if standard way is not suitable
  # node_groups.has_prefix(:node_group_name, :node_group_name_prefix) {|full| ...}
  # node_groups.has_no_prefixes # <- add attributes to disable particularly for those attributes

  launch_template_blk = node_groups.override_block(:launch_template)
  launch_template = launch_template_blk.belongs_to(:aws_launch_template)
    .where(name: launch_template_blk.resolved.name)
    .identify_by(:name)
  # launch_template.clearance ???

  launch_template_blk.enforce(version: launch_template.resolved.latest_version)

  ami = launch_template.has_optional_data(:aws_ami)
  launch_template.enforce(image_id: ami.resolved.image_id)

  launch_template.enforce(:lifecycle, ignore_changes: [launch_template.meta.tag_specifications[0].tags["Owner"]])
  launch_template.enforce_expression({user_data: <<-USERDATA
    base64encode(<<-EOT
      #!/bin/bash -xe

      # Bootstrap and join the cluster
      /etc/eks/bootstrap.sh --b64-cluster-ca '%{cluster_cert_authority_data}' --apiserver-endpoint '%{cluster_endpoint}' '%{cluster_id}'

      # Allow user supplied userdata code
      echo "Node is up..."
    EOT
    )
USERDATA
}, {
  cluster_cert_authority_data: eks_cluster.resolved.certificate_authority[0].data,
  cluster_endpoint: eks_cluster.resolved.endpoint,
  cluster_id: eks_cluster.resolved.id
})

  launch_template.enforce_expression(
    {tag_specifications: [{resource_type: "instance", tags: {"Name"=>"%{cluster_id}-worker"}}]},
    {cluster_id: eks_cluster.resolved.id}
  )

  launch_template.enforce(vpc_security_group_ids: [eks_cluster.resolved.vpc_config[0].cluster_security_group_id])
end
```


### Usage

```sh
# generate opentofu code (modules)
bundle exec str23 generate

# run dashboard
bundle exec str23 server
```

 
### Internal: result spec (in quasi-hcl)

```hcl
resource aws_eks_cluster this {}

data tls_certificate this {
  count = var.enable_aws_iam_openid_connect_provider ? 1 : 0
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource aws_iam_openid_connect_provider this {
  count = var.enable_aws_iam_openid_connect_provider ? 1 : 0
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
  thumbprint_list = [one(data.tls_certificate.this[*].certificates[0].sha1_fingerprint)]
}

resource aws_eks_addon this {
  for_each = var.aws_eks_addons
  name = each.key
  cluster_name = aws_eks_cluster.main.id

  depends_on = [
    aws_iam_openid_connect_provider.this,
  ]
}

data aws_ami this {
  for_each = {for key, value in var.aws_launch_templates : key => value.aws_ami if value.aws_ami != null}
  # any_attr = each.value.any_attr
}

resource aws_launch_template this {
  for_each = var.aws_launch_templates
  name = each.key
  image_id = each.value.aws_ami != null ? data.aws_ami.this[each.key].image_id : each.value.image_id
}

resource aws_eks_node_group this {
  for_each = var.aws_eks_node_groups
  node_group_name = each.value.use_key && each.value.use_key_as_node_group_name ? each.key : null
  node_group_name_prefix = each.value.use_key && !each.value.use_key_as_node_group_name ? each.key : null
  cluster_name = aws_eks_cluster.this.id

  launch_template {
    name = each.value.launch_template_key != null ? aws_launch_template.this[each.value.launch_template_key].name : each.value.launch_template.name
    version = each.value.launch_template_key != null ? aws_launch_template.this[each.value.launch_template_key].latest_version : each.value.launch_template.version
  }
}

```


### Internal: query (in quasi-API-requests)

```
clusters=$(aws eks describe-clusters)
clusters_map=$(clusters as map(cluster-id=>cluster-data))

connectproviders=$(aws iam describe-openid-connect-providers)
connectproviders_map=$(connectproviders as map(cluster-id=>connectprovider-id=>connectprovider-data))
validate connectproviders_map # only one or zero connectprovider per cluster
# mark non-valid cluster as rejected

addons=$(aws eks describe-addons)
addons_map=$(addons as map(cluster-id=>addon-id=>addon-data))

nodegroups=$(aws eks node-groups)
nodegroups_map=$(nodegroups as map(cluster-id=>nodegroup-id=>nodegroup-data))

launchtemplates=$(aws ec2 describe-launch-templates)
launchtemplates_map$(launchtemplates as map(launchtemplate-id=>(launchtemplate-data;cluster-id=>nodegroup-id))
# mark launch-templates with many cluster-id keys as skipped (+warning)
# move launch-templates with one cluster-id with many nodegroup-ids as common
# move launch-templates with one cluster-id with one nodegroup-id as dedicated

```