# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/eks_cluster
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/eks/cluster.go

resource "aws_eks_cluster" "this" {
  name = var.eks_cluster_name

  role_arn = var.eks_cluster_role_arn

  enabled_cluster_log_types = var.eks_cluster_enabled_cluster_log_types
  version                   = var.eks_cluster_version
  tags                      = var.eks_cluster_tags

  vpc_config {
    subnet_ids              = var.eks_cluster_vpc_config.subnet_ids
    endpoint_private_access = var.eks_cluster_vpc_config.endpoint_private_access
    endpoint_public_access  = var.eks_cluster_vpc_config.endpoint_public_access
    public_access_cidrs     = var.eks_cluster_vpc_config.public_access_cidrs
    security_group_ids      = var.eks_cluster_vpc_config.security_group_ids
  }

  bootstrap_self_managed_addons = var.eks_cluster_bootstrap_self_managed_addons

  dynamic "access_config" {
    for_each = var.eks_cluster_access_config != null ? [var.eks_cluster_access_config] : []
    content {
      authentication_mode                         = access_config.value.authentication_mode
      bootstrap_cluster_creator_admin_permissions = access_config.value.bootstrap_cluster_creator_admin_permissions
    }
  }

  dynamic "encryption_config" {
    for_each = var.eks_cluster_encryption_config != null ? [var.eks_cluster_encryption_config] : []
    content {
      dynamic "provider" {
        for_each = [encryption_config.value.provider]
        content {
          key_arn = provider.value.key_arn
        }
      }
      resources = encryption_config.value.resources
    }
  }

  dynamic "kubernetes_network_config" {
    for_each = var.eks_cluster_kubernetes_network_config != null ? [var.eks_cluster_kubernetes_network_config] : []
    content {
      service_ipv4_cidr = kubernetes_network_config.value.service_ipv4_cidr
      ip_family         = kubernetes_network_config.value.ip_family
    }
  }

  dynamic "outpost_config" {
    for_each = var.eks_cluster_outpost_config != null ? [var.eks_cluster_outpost_config] : []
    content {
      control_plane_instance_type = outpost_config.value.control_plane_instance_type
      dynamic "control_plane_placement" {
        for_each = outpost_config.value.control_plane_placement != null ? [outpost_config.value.control_plane_placement] : []
        content {
          group_name = control_plane_placement.value.group_name
        }
      }
      outpost_arns = outpost_config.value.outpost_arns
    }
  }

  dynamic "upgrade_policy" {
    for_each = var.eks_cluster_upgrade_policy != null ? [var.eks_cluster_upgrade_policy] : []
    content {
      support_type = upgrade_policy.value.support_type
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/tls/4.0.6/docs/data-sources/certificate

data "tls_certificate" "this" {
  count = var.iam_openid_connect_provider != null ? 1 : 0

  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/iam_openid_connect_provider

resource "aws_iam_openid_connect_provider" "this" {
  count = var.iam_openid_connect_provider != null ? 1 : 0

  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = try(var.iam_openid_connect_provider.client_id_list)
  thumbprint_list = [one(data.tls_certificate.this[*].certificates[0].sha1_fingerprint)]
  tags            = try(var.iam_openid_connect_provider.tags)
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/eks_addon
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/eks/addon.go

resource "aws_eks_addon" "this" {
  for_each = { for k, v in var.eks_addons : k => merge(var.eks_addons_common, v) if v.enabled }

  cluster_name                = aws_eks_cluster.this.id
  addon_name                  = each.key
  resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
  addon_version               = each.value.addon_version
  configuration_values        = each.value.configuration_values
  tags                        = each.value.tags
  preserve                    = each.value.preserve
  service_account_role_arn    = each.value.service_account_role_arn

  depends_on = [
    aws_iam_openid_connect_provider.this,
  ]
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/eks_node_group
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/eks/node_group.go

resource "aws_eks_node_group" "this" {
  for_each = { for k, v in var.eks_node_groups : k => merge(var.var.eks_node_groups_common, v) }

  cluster_name           = aws_eks_cluster.this.id
  node_group_name        = each.value.use_key && each.value.use_key_as_node_group_name ? each.key : null
  node_group_name_prefix = each.value.use_key && !each.value.use_key_as_node_group_name ? each.key : null

  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.eks_node_group_subnet_ids
  labels          = var.eks_node_group_labels
  capacity_type   = var.eks_node_group_capacity_type
  instance_types  = var.eks_node_group_instance_types

  scaling_config {
    desired_size = var.eks_node_group_desired_size
    max_size     = var.eks_node_group_max_size
    min_size     = var.eks_node_group_min_size
  }

  launch_template {
    name    = aws_launch_template.this.name
    version = aws_launch_template.this.latest_version
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

data "aws_ami" "this" {
  most_recent = true
  name_regex  = "amazon-eks-arm64-node-${aws_eks_cluster.this.version}-v*"

  owners = ["amazon"]
}

resource "aws_launch_template" "this" {
  name_prefix   = var.eks_node_group_launch_template_name
  ebs_optimized = "true"
  image_id      = data.aws_ami.this.image_id
  instance_type = var.eks_node_group_instance_types != null ? null : var.eks_node_group_instance_type
  key_name      = var.eks_node_group_ssh_key

  vpc_security_group_ids = [
    aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${aws_eks_cluster.this.id}-worker"
    }
  }

  lifecycle {
    ignore_changes = [
      tag_specifications[0].tags["Owner"]
    ]
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash -xe

    # Bootstrap and join the cluster
    /etc/eks/bootstrap.sh --b64-cluster-ca '${aws_eks_cluster.this.certificate_authority[0].data}' --apiserver-endpoint '${aws_eks_cluster.this.endpoint}' '${aws_eks_cluster.this.id}'

    # Allow user supplied userdata code
    echo "Node is up..."
  EOT
  )
}
