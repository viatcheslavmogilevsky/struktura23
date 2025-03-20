# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/eks_cluster
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/eks/cluster.go

# What 'id' came from:
# https://www.reddit.com/r/Terraform/comments/tur9as/comment/i3e7wy7/
# https://github.com/hashicorp/terraform-plugin-sdk/blob/v2.34.0/helper/schema/resource_data.go

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
# https://github.com/hashicorp/terraform-provider-tls/blob/v4.0.6/internal/provider/data_source_certificate.go

data "tls_certificate" "this" {
  count = var.iam_openid_connect_provider != null ? 1 : 0

  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/iam_openid_connect_provider
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/iam/openid_connect_provider.go

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
  for_each = local.merged_no_key_attrs["eks_addons"]

  cluster_name                = aws_eks_cluster.this.id
  addon_name                  = local.merged_key_attrs["eks_addons"][each.key].addon_name
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
  for_each = local.merged_no_key_attrs["eks_node_groups"]

  cluster_name = aws_eks_cluster.this.id

  # ..name_prefix can be found from ..name
  # suffix example: 20241118090004730600000001

  node_group_name        = local.merged_key_attrs["eks_node_groups"][each.key].node_group_name
  node_group_name_prefix = local.merged_key_attrs["eks_node_groups"][each.key].node_group_name_prefix
  node_role_arn          = each.value.node_role_arn
  subnet_ids             = each.value.subnet_ids
  ami_type               = each.value.ami_type
  capacity_type          = each.value.capacity_type
  disk_size              = each.value.disk_size
  force_update_version   = each.value.force_update_version
  instance_types         = each.value.instance_types
  labels                 = each.value.labels
  release_version        = each.value.release_version
  tags                   = each.value.tags
  taint                  = each.value.taint
  version                = each.value.version

  scaling_config {
    desired_size = try(each.value.scaling_config.desired_size)
    max_size     = try(each.value.scaling_config.max_size)
    min_size     = try(each.value.scaling_config.min_size)
  }

  dynamic "launch_template" {
    for_each = each.value.launch_template != null ? [each.value.launch_template] : []
    content {
      name    = launch_template.launch_template_key != null ? aws_launch_template.main[launch_template.value.launch_template_key].name : launch_template.name
      version = launch_template.launch_template_key != null ? aws_launch_template.main[launch_template.value.launch_template_key].latest_version : launch_template.version
    }
  }

  dynamic "remote_access" {
    for_each = each.value.remote_access != null ? [each.value.remote_access] : []
    content {
      ec2_ssh_key = remote_access.value.ec2_ssh_key
      source_security_group_ids = remote_access.value.source_security_group_ids
    }
  }

  dynamic "update_config" {
    for_each = each.value.update_config != null ? [each.value.update_config] : []
    content {
      max_unavailable = update_config.value.max_unavailable
      max_unavailable_percentage = update_config.value.max_unavailable_percentage
    }
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/data-sources/ami
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/ec2/ec2_ami_data_source.go

data "aws_ami" "this" {
  for_each = {for key, value in local.merged_no_key_attrs["launch_templates"] : key => value.ami if value.ami != null}

  owners      = each.value.owners
  most_recent = each.value.most_recent
  executable_users = each.value.executable_users
  include_deprecated = each.value.include_deprecated
  name_regex  =  each.value.name_regex

  # IAMHERE: what's dynamic block internal structure in statefile?
  dynamic "filter" {
    for_each = each.value.filter != null ? each.value.filter : []
    content {
      name = filter.value.name
      values = filter.value.values
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/launch_template
# https://github.com/hashicorp/terraform-provider-aws/blob/v5.72.1/internal/service/ec2/ec2_launch_template.go

resource "aws_launch_template" "this" {
  for_each = local.merged_no_key_attrs["launch_templates"]

  name        = local.merged_key_attrs["launch_templates"][each.key].name
  name_prefix = local.merged_key_attrs["launch_templates"][each.key].name_prefix
  image_id    = each.value.aws_ami != null ? data.aws_ami.this[each.key].image_id : each.value.image_id


    # 0..N blocks:
    # block_device_mappings
    # elastic_gpu_specifications
    # license_specification
    # network_interfaces
    # tag_specifications

    # 0..1 blocks:
    # capacity_reservation_specification
    # cpu_options
    # credit_specification
    # elastic_inference_accelerator
    # enclave_options
    # hibernation_options
    # iam_instance_profile
    # instance_market_options
    # instance_requirements
    # maintenance_options
    # metadata_options
    # monitoring
    # placement
    # private_dns_name_options

      # set_attrs = [
      #   "license_specification",
      #   "security_group_names",
      #   "vpc_security_group_ids",
      # ]
      # key_attrs = [
      #   "name",
      #   "name_prefix",
      # ]
      # no_key_attrs = [
      #   "ami",
      #   "block_device_mappings",
      #   "capacity_reservation_specification",
      #   "cpu_options",
      #   "credit_specification",
      #   "default_version",
      #   "description",
      #   "disable_api_stop",
      #   "disable_api_termination",
      #   "ebs_optimized",
      #   "elastic_gpu_specifications",
      #   "elastic_inference_accelerator",
      #   "enclave_options",
      #   "hibernation_options",
      #   "iam_instance_profile",
      #   "image_id",
      #   "instance_initiated_shutdown_behavior",
      #   "instance_market_options",
      #   "instance_requirements",
      #   "instance_type",
      #   "kernel_id",
      #   "key_name",
      #   "license_specification",
      #   "maintenance_options",
      #   "metadata_options",
      #   "monitoring",
      #   "network_interfaces",
      #   "placement",
      #   "private_dns_name_options",
      #   "ram_disk_id",
      #   "security_group_names",
      #   "tag_specifications",
      #   "tags",
      #   "update_default_version",
      #   "vpc_security_group_ids",
}

# resource "aws_launch_template" "this" {
#   for_each = local.launch_templates


#   name_prefix   = var.eks_node_group_launch_template_name
#   ebs_optimized = "true"
#   image_id      = data.aws_ami.this.image_id
#   instance_type = var.eks_node_group_instance_types != null ? null : var.eks_node_group_instance_type
#   key_name      = var.eks_node_group_ssh_key

#   vpc_security_group_ids = [
#     aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
#   ]

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = "${aws_eks_cluster.this.id}-worker"
#     }
#   }

#   lifecycle {
#     ignore_changes = [
#       tag_specifications[0].tags["Owner"]
#     ]
#   }

#   user_data = base64encode(<<-EOT
#     #!/bin/bash -xe

#     # Bootstrap and join the cluster
#     /etc/eks/bootstrap.sh --b64-cluster-ca '${aws_eks_cluster.this.certificate_authority[0].data}' --apiserver-endpoint '${aws_eks_cluster.this.endpoint}' '${aws_eks_cluster.this.id}'

#     # Allow user supplied userdata code
#     echo "Node is up..."
#   EOT
#   )
# }
