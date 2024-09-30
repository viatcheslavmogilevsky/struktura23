# New design

## Idea

```
str23 class -> opentofu code (module)
            -> query -> opentofu code (module usage)
```


## Example

### ModuleSpec example

```rb
class ExampleStruktura < Struktura23::ModuleSpec
  eks_cluster = module_itself.has_one(:aws_eks_cluster).identify_by(:name)

  connect_provider = eks_cluster.has_optional(:aws_iam_openid_connect_provider).where(url: eks_cluster.resolved.identity[0].oidc[0].issuer)
  tls_certificate = connect_provider.has_one_data(:tls_certificate).where(url: eks_cluster.resolved.identity[0].oidc[0].issuer)
  connect_provider.enforce(thumbprint_list: [tls_certificate.resolved.certificates[0].sha1_fingerprint])
 
  eks_cluster.has_many(:aws_eks_addon).where(cluster_name: eks_cluster.resolved.id).identify_by(:name)

  node_groups = eks_cluster.has_many(:aws_eks_node_group).where(cluster_name: eks_cluster.resolved.id).identify_by(:node_group_name)
  launch_template = node_groups.belongs_to(:aws_launch_template).where(name: node_groups.resolved.launch_template.name).identify_by(:name)
  node_groups.enforce(node_groups.resolved.launch_template.version=>launch_template.resolved.latest_version)

  ami = launch_template.has_optional_data(:aws_ami)
  launch_template.enforce(image_id: ami.resolved.image_id)
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
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
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
}

resource aws_launch_template dedicated_to_aws_eks_node_group {
  for_each = var.aws_eks_node_groups
  name = each.value.aws_launch_template.name
  image_id = each.value.enabled_aws_ami ? data.aws_ami.dedicated_to_aws_eks_node_group[each.key].image_id : each.value.aws_launch_template.image_id
}

data aws_ami dedicated_to_aws_eks_node_group {
  for_each = {for aws_eks_node_group_key, aws_eks_node_group_value in var.aws_eks_node_groups: 
    aws_eks_node_group_key => aws_eks_node_group_value if aws_eks_node_group_value.enable_aws_ami
  }
  # any_attr = each.value.aws_launch_template.aws_ami.any_attr
}

resource aws_launch_template common {
  for_each = var.common_aws_launch_templates
  name = each.key
  image_id = each.value.enabled_aws_ami ? data.aws_ami.common[each.key].image_id : each.value.image_id
}

data aws_ami common {
  for_each = {for common_aws_launch_template_key, common_aws_launch_template_value in var.common_aws_launch_templates: 
    common_aws_launch_template_key => common_aws_launch_template_value if common_aws_launch_template_value.enable_aws_ami
  }
  # any_attr = each.value.aws_ami.any_attr
}

locals {
  common_names = {for aws_eks_node_group_key, aws_eks_node_group_value in var.aws_eks_node_groups :
    aws_eks_node_group_key => aws_eks_node_group_value.aws_launch_template_key != null ? aws_launch_template.common[aws_eks_node_group_key].name : aws_eks_node_group_value.launch_template
  }

  common_versions = {for aws_eks_node_group_key, aws_eks_node_group_value in var.aws_eks_node_groups :
    aws_eks_node_group_key => aws_eks_node_group_value.aws_launch_template_key != null ? aws_launch_template.common[aws_eks_node_group_key].latest_version : aws_eks_node_group_value.launch_template.latest_version
  }

  launch_template_names = {for aws_eks_node_group_key, aws_eks_node_group_value in var.aws_eks_node_groups :
    aws_eks_node_group_key => aws_eks_node_group_value.aws_launch_template != null ? aws_launch_template.dedicated_to_aws_eks_node_group[aws_eks_node_group_key].name : local.common_names[aws_eks_node_group_key]
  }

  launch_template_versions = {for aws_eks_node_group_key, aws_eks_node_group_value in var.aws_eks_node_groups :
    aws_eks_node_group_key => aws_eks_node_group_value.aws_launch_template != null ? aws_launch_template.dedicated_to_aws_eks_node_group[aws_eks_node_group_key].latest_version : local.common_versions[aws_eks_node_group_key]
  }
}

resource aws_eks_node_group this {
  for_each = var.aws_eks_node_groups
  node_group_name = each.key
  cluster_name = aws_eks_cluster.main.id

  launch_template {
    name = local.launch_template_names[each.key]
    version = local.launch_template_versions[each.key]
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