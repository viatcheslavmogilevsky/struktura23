require 'module-spec'

cluster =  one :aws_eks_cluster

connect_providers = many :aws_iam_openid_connect_provider do |c|
    max_count 1

    c.url cluster.identity[0].oidc[0].issuer
    c.client_id_list ["sts.amazonaws.com"]
    c.thumbprint_list [tls_certificate.certificates[0].sha1_fingerprint]
end

addons = many :aws_eks_addon do |a|
    a.cluster_name cluster.id
end

tls_certificate = one :tls_certificate, readonly: true do |tc|
    tc.url identity[0].oidc[0].issuer
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








