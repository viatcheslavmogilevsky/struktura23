# New design

## Idea

```
str23 class -> opentofu code (module)
            -> query -> opentofu code (module usage)
```


## Example


```rb
class ExampleStruktura < Struktura23::BaseSpec
  eks_cluster = has_root(:aws_eks_cluster).identify_by(:id)

  tls_certificate = eks_cluster.has_one_data(:tls_certificate).where(url: eks_cluster.resolved.identity[0].oidc[0].issuer)
  connect_provider = eks_cluster.has_optional(:aws_iam_openid_connect_provider).where(url: eks_cluster.resolved.identity[0].oidc[0].issuer)
  connect_provider.enforce(thumbprint_list: [tls_certificate.resolved.certificates[0].sha1_fingerprint])
 
  eks_cluster.has_many(:aws_eks_addon).where(cluster_name: eks_cluster.resolved.id).identify_by(:name)

  node_groups = eks_cluster.has_many(:aws_eks_node_group).where(cluster_name: eks_cluster.resolved.id).identify_by(:node_group_name)
  launch_template = node_groups.belongs_to(:aws_launch_template).where(name: node_groups.resolved.launch_template.name).identify_by(:id)
  node_groups.enforce(node_groups.resolved.launch_template.version=>launch_template.resolved.latest_version)

  ami = launch_template.has_optional_data(:aws_ami)
  launch_template.enforce_expression(
    {image_id: "%{is_data_enabled} ? %{image_from_data} : %{default}"},
    {is_data_enabled: ami.enabled?, image_from_data: ami.resolved.image_id}
  )
end
```