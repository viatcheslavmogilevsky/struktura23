output "static_resource_example_output" {
  value = terraform_data.static_resource_example.output
}

output "static_resource_example_output_safe" {
  value = lookup(terraform_data.static_resource_example, "output", null)
}

output "static_resource_example_putout_safe" {
  value = lookup(terraform_data.static_resource_example, "putout", null)
}

output "count_resource_example_output" {
  value = one(terraform_data.count_resource_example[*].output)
}

output "count_resource_example_output_safe" {
  value = one([for elem in terraform_data.count_resource_example : lookup(elem, "output", null)])
}

output "count_resource_example_putout_safe" {
  value = one([for elem in terraform_data.count_resource_example : lookup(elem, "putout", null)])
}

output "for_each_resource_example_output" {
  value = { for k, v in var.for_each_key_val : k => terraform_data.for_each_resource_example[k].output }
}

output "for_each_resource_example_output_safe" {
  value = { for k, v in var.for_each_key_val : k => lookup(terraform_data.for_each_resource_example[k], "output", null) }
}

output "for_each_resource_example_putout_safe" {
  value = { for k, v in var.for_each_key_val : k => lookup(terraform_data.for_each_resource_example[k], "putout", null) }
}
