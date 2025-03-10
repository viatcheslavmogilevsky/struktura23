locals {
  for_each_input = {
    eks_addons = {
      input = var.eks_addons
      set_attrs = []
      key_attrs = [
        "addon_name",
      ]
      no_key_attrs = [
        "resolve_conflicts_on_create",
        "resolve_conflicts_on_update",
        "addon_version",
        "configuration_values",
        "tags",
        "preserve",
        "service_account_role_arn",
      ]
    },
    eks_node_groups = {
      input = var.eks_node_groups
      set_attrs = [
        "taint",
      ]
      key_attrs = [
        "node_group_name",
        "node_group_name_prefix",
      ]
      no_key_attrs = [
        "node_role_arn",
        "scaling_config",
        "subnet_ids",
        "ami_type",
        "capacity_type",
        "disk_size",
        "force_update_version",
        "instance_types",
        "labels",
        "launch_template",
        "release_version",
        "remote_access",
        "tags",
        "taint",
        "update_config",
        "version",
      ]
    },
    launch_templates = {
      input = var.launch_templates
      set_attrs = [
        "license_specification",
        "security_group_names",
        "vpc_security_group_ids",
      ]
      key_attrs = [
        "name",
        "name_prefix",
      ]
      no_key_attrs = [
        "ami",
        "block_device_mappings",
        "capacity_reservation_specification",
        "cpu_options",
        "credit_specification",
        "default_version",
        "description",
        "disable_api_stop",
        "disable_api_termination",
        "ebs_optimized",
        "elastic_gpu_specifications",
        "elastic_inference_accelerator",
        "enclave_options",
        "hibernation_options",
        "iam_instance_profile",
        "image_id",
        "instance_initiated_shutdown_behavior",
        "instance_market_options",
        "instance_requirements",
        "instance_type",
        "kernel_id",
        "key_name",
        "license_specification",
        "maintenance_options",
        "metadata_options",
        "monitoring",
        "network_interfaces",
        "placement",
        "private_dns_name_options",
        "ram_disk_id",
        "security_group_names",
        "tag_specifications",
        "tags",
        "update_default_version",
        "vpc_security_group_ids",
      ]
    },
  }

  for_each_common = {
    for input_key, input_value in local.for_each_input : input_key => lookup(input_value["input"], "_common", merge(
    {
      enabled = true
      use_key_as = null
      customize_common = {}
    }, {
      for attr_name in input_value["no_key_attrs"] : attr_name => null
    }))
  }

  merged_no_key_attrs = {
    for input_key, input_value in local.for_each_input : input_key => {
      for resource_key, resource_value in input_value["input"] : resource_key => {
        for attr_name, attr_value in resource_value : attr_name => (lookup(resource_value["customize_common"], attr_name, "default") == "omit" || (local.for_each_common[input_key][attr_name] == null && attr_value == null) ?
          null
          : (lookup(resource_value["customize_common"], attr_name, "default") == "merge" && local.for_each_common[input_key][attr_name] != null ?
            merge(local.for_each_common[input_key][attr_name], coalesce(attr_value, {}))
            : (lookup(resource_value["customize_common"], attr_name, "default") == "append" && local.for_each_common[input_key][attr_name] != null && contains(local.for_each_input[input_key]["set_attrs"], attr_name) ?
              setunion(local.for_each_common[input_key][attr_name], coalesce(attr_value, toset([])))
              : (lookup(resource_value["customize_common"], attr_name, "default") == "append" && local.for_each_common[input_key][attr_name] != null ?
                concat(local.for_each_common[input_key][attr_name], coalesce(attr_value, []))
                : (lookup(resource_value["customize_common"], attr_name, "default") == "prepend" && local.for_each_common[input_key][attr_name] != null ?
                  concat(coalesce(attr_value, []), local.for_each_common[input_key][attr_name])
        : coalesce(attr_value, local.for_each_common[input_key][attr_name]))))))
      } if resource_value.enabled && resource_key != "_common"
    }
  }

  merged_key_attrs = {
    for input_key, input_value in local.for_each_input : input_key => {
      for resource_key, resource_value in input_value["input"] : resource_key => {
        for attr_name in local.for_each_input[input_key]["key_attrs"] : attr_name => (coalesce(resource_value["use_key_as"], local.for_each_common[input_key]["use_key_as"], local.for_each_input[input_key]["key_attrs"][0]) == attr_name ?
        resource_key
        : null)
      } if resource_value.enabled && resource_key != "_common"
    }
  }
}

resource "terraform_data" "eks_addon" {
  for_each = local.merged_no_key_attrs["eks_addons"]

  input = {
    cluster_name                = "awesome-cluster"
    addon_name                  = local.merged_key_attrs["eks_addons"][each.key].addon_name

    resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
    resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
    addon_version               = each.value.addon_version
    configuration_values        = each.value.configuration_values
    tags                        = each.value.tags
    preserve                    = each.value.preserve
    service_account_role_arn    = each.value.service_account_role_arn
  }
}

resource "terraform_data" "eks_node_group" {
  for_each = local.merged_no_key_attrs["eks_node_groups"]

  input = {
    cluster_name = "awesome-cluster"

    # on aws_eks_node_group resource it will look like this:
    # dynamic "launch_template" {
    #   for_each = each.value.launch_template != null ? [each.value.launch_template] : []
    #   content {
    #     name    = launch_template.launch_template_key != null ? aws_launch_template.main[launch_template.value.launch_template_key].name : launch_template.name
    #     version = launch_template.launch_template_key != null ? aws_launch_template.main[launch_template.value.launch_template_key].latest_version : launch_template.version
    #   }
    # }
    launch_template = (each.value.launch_template != null ? {
      name = (each.value.launch_template.launch_template_key != null ?
        "${lookup(terraform_data.launch_template[each.value.launch_template.launch_template_key].output, "name", "")}${lookup(terraform_data.launch_template[each.value.launch_template.launch_template_key].output, "name_prefix", "")}"
        : each.value.launch_template.name)
      version = (each.value.launch_template.launch_template_key != null ?
        length(jsonencode(terraform_data.launch_template[each.value.launch_template_key].output))
        : each.value.launch_template.version)
    } : null)

    node_group_name        = local.merged_key_attrs["eks_node_groups"][each.key].node_group_name
    node_group_name_prefix = local.merged_key_attrs["eks_node_groups"][each.key].node_group_name_prefix

    node_role_arn          = each.value.node_role_arn
    scaling_config         = each.value.scaling_config
    subnet_ids             = each.value.subnet_ids
    ami_type               = each.value.ami_type
    capacity_type          = each.value.capacity_type
    disk_size              = each.value.disk_size
    force_update_version   = each.value.force_update_version
    instance_types         = each.value.instance_types
    labels                 = each.value.labels
    release_version        = each.value.release_version

    # on aws_eks_node_group resource it will look like this:
    # dynamic "remote_access" {
    #   for_each = each.value.remote_access != null ? [each.value.remote_access] : []
    #   content {
    #     ec2_ssh_key = remote_access.value.ec2_ssh_key
    #     source_security_group_ids = remote_access.value.source_security_group_ids
    #   }
    # }
    remote_access          = each.value.remote_access

    tags                   = each.value.tags
    taint                  = each.value.taint

    # on aws_eks_node_group resource it will look like this:
    # dynamic "update_config" {
    #   for_each = each.value.update_config != null ? [each.value.update_config] : []
    #   content {
    #     max_unavailable = update_config.value.max_unavailable
    #     max_unavailable_percentage = update_config.value.max_unavailable_percentage
    #   }
    # }
    update_config          = each.value.update_config

    version                = each.value.version
  }
}


resource "terraform_data" "ami" {
  for_each = {for key, value in local.merged_no_key_attrs["launch_templates"] : key => value.ami if value.ami != null}

  input = {
    owners             = each.value.owners
    most_recent        = each.value.most_recent
    executable_users   = each.value.executable_users
    include_deprecated = each.value.include_deprecated
    name_regex         = each.value.name_regex

    # on aws_ami datasource it will look like this:
    # dynamic "filter" {
    #   for_each = each.value.filter != null ? each.value.filter : []
    #   content {
    #     name = filter.value.name
    #     values = filter.value.values
    #   }
    # }
    filter = each.value.filter
  }
}

resource "terraform_data" "launch_template" {
  for_each = local.merged_no_key_attrs["launch_templates"]

  input = {
    # on aws_launch_template resource it will look like this:
    # image_id = each.value.aws_ami != null ? data.aws_ami.this[each.key].image_id : each.value.image_id
    image_id = each.value.ami != null ? sha256(jsonencode(terraform_data.ami[each.key].output)) : each.value.image_id

    name        = local.merged_key_attrs["launch_templates"][each.key].name
    name_prefix = local.merged_key_attrs["launch_templates"][each.key].name_prefix
  }
}
