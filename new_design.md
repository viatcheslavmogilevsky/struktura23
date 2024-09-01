# New design

## Idea

```
str23 class -> opentofu code (module)
            -> query -> opentofu code (module usage)
```


## Example


```rb
class ExampleStruktura < Struktura23::BaseSpec
  # has_compound(:lt_wrapper)
  eks_cluster = has_root(:aws_eks_cluster).identify {|found_cluster| found_cluster.id}

  eks_cluster.has_one_data(:tls_certificate).where {|cluster| url: cluster.found.identity[0].oidc[0].issuer}
  eks_cluster.has_optional(:aws_iam_openid_connect_provider).where {|cluster| url: cluster.found.identity[0].oidc[0].issuer}
  eks_cluster.has_many(:aws_eks_addon).identify {|found_addon| found_addon.name}.where {|cluster| cluster_name: cluster.found.id}

  node_groups = eks_cluster.has_many(:aws_eks_node_group).where {|cluster| cluster_name: cluster.found.id }.identify {|found_group| found_group.node_group_name}
  node_groups.belongs_to(:aws_launch_template).where {||}
end
```