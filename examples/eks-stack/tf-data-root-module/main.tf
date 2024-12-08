locals {
  # main = "1"

  empty_eks_addon = {
    enabled = true

    resolve_conflicts_on_create = null
    resolve_conflicts_on_update = null
    addon_version               = null
    configuration_values        = null
    tags                        = null
    preserve                    = null
    service_account_role_arn    = null

    customize_common = {}
  }

  common_eks_addon = lookup(var.eks_addons, "_common", local.empty_eks_addon)

  eks_addons_set_attrs = []

  merged_eks_addons = {
    for k, v in var.eks_addons : k => {
      for attr_name, attr_value in v : attr_name => (lookup(v["customize_common"], attr_name, "default") == "omit" || (local.common_eks_addon[attr_name] == null && attr_value == null) ?
        null
        : (lookup(v["customize_common"], attr_name, "default") == "merge" && local.common_eks_addon[attr_name] != null ?
          merge(local.common_eks_addon[attr_name], coalesce(attr_value, {}))
          : (lookup(v["customize_common"], attr_name, "default") == "append" && local.common_eks_addon[attr_name] != null && contains(local.eks_addons_set_attrs, attr_name) ?
            setunion(local.common_eks_addon[attr_name], coalesce(attr_value, toset([])))
            : (lookup(v["customize_common"], attr_name, "default") == "append" && local.common_eks_addon[attr_name] != null ?
              concat(local.common_eks_addon[attr_name], coalesce(attr_value, []))
              : (lookup(v["customize_common"], attr_name, "default") == "prepend" && local.common_eks_addon[attr_name] != null ?
                concat(coalesce(attr_value, []), local.common_eks_addon[attr_name])
      : coalesce(attr_value, local.common_eks_addon[attr_name]))))))
    } if v.enabled && k != "_common"
  }
  # merged_eks_addons = {
  #   for k, v in var.eks_addons : k => merge(local.common_eks_addon, v) if v.enabled && k != "_common"
  # }
}

# resource "terraform_data" "local" {
#   input = local.main
# }

resource "terraform_data" "eks_addon" {
  for_each = local.merged_eks_addons

  input = {
    cluster_name                = "awesome-cluster"
    addon_name                  = each.key
    resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
    resolve_conflicts_on_update = each.value.resolve_conflicts_on_update #   try(coalesce(local.common_eks_addon.resolve_conflicts_on_update, each.value.resolve_conflicts_on_update), null)
    addon_version               = each.value.addon_version               # try(coalesce(local.common_eks_addon.addon_version, each.value.addon_version), null)
    configuration_values        = each.value.configuration_values        # try(coalesce(local.common_eks_addon.configuration_values, each.value.configuration_values), null)
    tags                        = each.value.tags                        # contains(each.value.merge_common, "tags") && local.common_eks_addon.tags != null ? merge(local.common_eks_addon.tags, coalesce(each.value.tags, {})) : each.value.tags
    preserve                    = each.value.preserve                    # try(coalesce(local.common_eks_addon.preserve, each.value.preserve), null)
    service_account_role_arn    = each.value.service_account_role_arn    # try(coalesce(local.common_eks_addon.service_account_role_arn, each.value.service_account_role_arn), null)
  }
}
