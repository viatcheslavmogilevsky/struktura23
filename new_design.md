# New design

## Idea

```
str23 class -> opentofu code (module)
            -> query -> opentofu code (module usage)
```


## Example


```rb
class ExampleStruktura < Struktura23::BaseSpec
  eks_cluster = has_root(:aws_eks_cluster).identify_by {|found_cluster| found_cluster.id}

  eks_cluster.has_one_data(:tls_certificate).where {|core| url: core.found.identity[0].oidc[0].issuer}
  eks_cluster.has_optional(:aws_iam_openid_connect_provider).where {|core| url: core.found.identity[0].oidc[0].issuer}
  eks_cluster.has_many(:aws_eks_addon).identify_by {|found_addon| found_addon.name}.where {|core| cluster_name: core.found.id}
end
```