require 'module-spec'

cluster = ModuleSpec::one :aws_eks_cluster

tls_certificate = cluster.has_one :tls_certificate do |cert, root|
    cert.readonly true
    cert.where_equal :url, root.identity[0].oidc[0].issuer
end

connect_providers = cluster.has_many :aws_iam_openid_connect_provider do |providers, root|
    providers.max_count 1

    providers.where_equal do |pr|
        pr.url root.identity[0].oidc[0].issuer
        pr.client_id_list ["sts.amazonaws.com"]
        pr.thumbprint_list [tls_certificate.certificates[0].sha1_fingerprint]
    end
end

addons = cluster.has_many :aws_eks_addon do |addons, root|
    addons.where_equal :cluster_name, root.id
end

templates = cluster.has_many :aws_launch_template do |lt, root|
    lt.where_true do |template|
        /bootstrap\.sh.+[\"\'\s]#{root.id}[\"\']\s*$/ =~ ModuleSpec::Utils.base64decode(lt.user_data)
    end
end

# templates.each.has_many TBD








