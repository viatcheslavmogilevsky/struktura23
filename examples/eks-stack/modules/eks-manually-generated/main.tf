# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster

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
    for_each = var.eks_cluster_access_config != null ? [0] : []
    content {
      authentication_mode                         = try(var.eks_cluster_access_config.authentication_mode, null)
      bootstrap_cluster_creator_admin_permissions = try(var.eks_cluster_access_config.bootstrap_cluster_creator_admin_permissions, null)
    }
  }

  dynamic "encryption_config" {
    for_each = var.eks_cluster_encryption_config != null ? [0] : []
    content {
      dynamic "provider" {
        for_each = var.eks_cluster_encryption_config != null && var.eks_cluster_encryption_config.provider != null ? [0] : []
        content {
          key_arn = try(var.eks_cluster_encryption_config.provider.key_arn, null)
        }
      }
      resources = try(var.eks_cluster_encryption_config.resources, null)
    }
  }

  dynamic "kubernetes_network_config" {
    for_each = var.eks_cluster_kubernetes_network_config != null ? [0] : []
    content {
      service_ipv4_cidr = try(var.eks_cluster_kubernetes_network_config.service_ipv4_cidr, null)
      ip_family         = try(var.eks_cluster_kubernetes_network_config.ip_family, null)
    }
  }

  dynamic "outpost_config" {
    for_each = var.eks_cluster_outpost_config != null ? [0] : []
    content {
      control_plane_instance_type = try(var.eks_cluster_outpost_config.control_plane_instance_type, null)
      dynamic "control_plane_placement" {
        for_each = var.eks_cluster_outpost_config != null && var.eks_cluster_outpost_config.control_plane_placement != null ? [0] : []
        content {
          group_name = try(var.eks_cluster_outpost_config.control_plane_placement.group_name, null)
        }
      }
      outpost_arns = try(var.eks_cluster_outpost_config.outpost_arns, null)
    }
  }

  dynamic "upgrade_policy" {
    for_each = var.eks_cluster_upgrade_policy != null ? [0] : []
    content {
      support_type = try(var.eks_cluster_upgrade_policy.support_type, null)
    }
  }

  # dynamic "zonal_shift_config" {
  #   for_each = var.eks_cluster_zonal_shift_config != null ? [0] : []
  #   content {
  #     enabled = try(var.eks_cluster_zonal_shift_config.enabled, null)
  #   }
  # }
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
}

resource "aws_eks_addon" "this" {
  for_each                    = toset(["vpc-cni", "kube-proxy", "coredns"])
  cluster_name                = aws_eks_cluster.this.id
  addon_name                  = each.key
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_iam_openid_connect_provider.this,
  ]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.id
  node_group_name = var.eks_node_group_name
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
