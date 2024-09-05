# New design

## Idea

```
str23 class -> opentofu code (module)
            -> query -> opentofu code (module usage)
```


## Example


```rb
class ExampleStruktura < Struktura23::BaseSpec
  eks_cluster = has_root(:aws_eks_cluster).identify {|found_cluster| found_cluster.id}

  eks_cluster.has_one_data(:tls_certificate).where {|cluster| url: cluster.found.identity[0].oidc[0].issuer}
  eks_cluster.has_optional(:aws_iam_openid_connect_provider).where {|cluster| url: cluster.found.identity[0].oidc[0].issuer}
  eks_cluster.has_many(:aws_eks_addon).identify {|found_addon| found_addon.name}.where {|cluster| cluster_name: cluster.found.id}

  node_groups = eks_cluster.has_many(:aws_eks_node_group).where {|cluster| cluster_name: cluster.found.id }.identify {|found_group| found_group.node_group_name}
  launch_template = node_groups.belongs_to(:aws_launch_template).where {|node_group| name: node_group.launch_template.name}
  node_groups.enforce(:"launch_template.version") {|node_group| node_group.node(:aws_launch_template).latest_version}
  launch_template.has_optional_data(:aws_ami)
  launch_template.enforce(:image_id) {|lt| lt.optional_node(:aws_ami).image_id}
end
```