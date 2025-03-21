locals {
  for_each_input = {
    eks_addons = {
      input     = var.eks_addons
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
        enabled          = true
        use_key_as       = null
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
