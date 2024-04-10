require 'module-spec'

cluster = :aws_eks_cluster.single

connect_providers = :aws_iam_openid_connect_provider.many do |c|
    max_count 1

    c.url cluster.identity[0].oidc[0].issuer
    c.client_id_list ["sts.amazonaws.com"]
    c.thumbprint_list [tls_certificate.certificates[0].sha1_fingerprint]
end

addons = :aws_eks_addon.many do |a|
    a.cluster_name cluster.id
end

tls_certificate = :tls_certificate.single(readonly: true) do |tc|
    tc.url identity[0].oidc[0].issuer
end

templates = :aws_launch_template.many do |lt|
    where do
        # length(
        #   regexall(
        #     "bootstrap\\.sh.+[\\\"\\'\\s]${aws_eks_cluster.main.id}[\\\"\\']?\\s*$",
        #     base64decode(aws_launch_template.main.user_data)
        #   )
        # ) > 0
    end
end








