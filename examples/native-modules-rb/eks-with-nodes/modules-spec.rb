require 'module-spec'

cluster = ModuleSpec::one :aws_eks_cluster

tls_certificate = cluster.has_one :tls_certificate do |cert, root|
    cert.data_source true
    cert.where_equal url: root.identity[0].oidc[0].issuer
end

cluster.has_many :aws_iam_openid_connect_provider do |providers, root|
    providers.max_count 1

    providers.where_equal {
        :url => root.identity[0].oidc[0].issuer,
        :client_id_list => ["sts.amazonaws.com"],
        :thumbprint_list => [tls_certificate.call().certificates[0].sha1_fingerprint]
    }
end

cluster.has_many :aws_eks_addon do |addons, root|
    addons.where_equal cluster_name: root.id
end

templates = cluster.has_many :aws_launch_template do |lt, root|
    lt.where_true do |template|
        /bootstrap\.sh.+[\"\'\s]#{root.id}[\"\']\s*$/ =~ ModuleSpec::Utils.base64decode(template.user_data)
    end
end

templates.each do |template|
    templates.has_many :aws_eks_node_group do |groups, root|
        groups.where {
            :cluster_name => cluster.id,
            :"launch_template.name" => root.name
        }
    end
end



ModuleSpec::scan cluster


# export for enforcing feature???











