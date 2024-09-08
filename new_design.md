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
  launch_template = node_groups.belongs_to(:aws_launch_template).where {|node_group| name: node_group.found.launch_template.name}
  node_groups.enforce(:"launch_template.version") {|node_group| launch_template.found_at(node_group).latest_version}

  ami = launch_template.has_optional_data(:aws_ami)
  launch_template.enforce_expr(:image_id, "%{is_data_enabled} ? %{image_from_data} : %{default}") do |lt, default|
    {:is_data_enabled=>ami.found_at?(lt), :image_from_data=>ami.found_at(lt)&.image_id, :default=>default}
  end
end
```