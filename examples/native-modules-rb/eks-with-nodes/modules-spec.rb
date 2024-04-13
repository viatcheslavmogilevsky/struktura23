require 'module-spec'

cluster = ModuleSpec::one :aws_eks_cluster

tls_certificate = one :tls_certificate, readonly: true do |tc, root|
    tc.url root.identity[0].oidc[0].issuer
end

connect_providers = cluster.has_many :aws_iam_openid_connect_provider do |providers, root|
    providers.max_count 1

    providers.where_equal do |pr|
        pr.url root.identity[0].oidc[0].issuer
        pr.client_id_list ["sts.amazonaws.com"]
        pr.thumbprint_list [tls_certificate.certificates[0].sha1_fingerprint]
    end
end

connect_providers = many :aws_iam_openid_connect_provider do |c|
    max_count 1

    c.url cluster.identity[0].oidc[0].issuer
    c.client_id_list ["sts.amazonaws.com"]
    c.thumbprint_list [tls_certificate.certificates[0].sha1_fingerprint]
end

addons = many :aws_eks_addon do |a|
    a.cluster_name cluster.id
end



templates = many :aws_launch_template do |lt|
    where do

        # length(
        #   regexall(
        #     "bootstrap\\.sh.+[\\\"\\'\\s]${aws_eks_cluster.main.id}[\\\"\\']?\\s*$",
        #     base64decode(aws_launch_template.main.user_data)
        #   )
        # ) > 0
    end
end








