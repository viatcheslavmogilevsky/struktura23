# New design


## Example


```rb
class ExampleStruktura < Struktura23::BaseSpec
  eks_cluster = has_root :aws_eks_cluster
  eks_cluster.identify_by :id

  tls_cert = eks_cluster.has_one_data(:tls_certificate)
  tls_cert.where url: tls_cert.core.found.identity[0].oidc[0].issuer
end
```