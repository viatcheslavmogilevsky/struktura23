resource "terraform_data" "static_resource_example" {
  input = {
    parameter01 = var.parameter01
  }
}

resource "terraform_data" "count_resource_example" {
  count = var.parameter02 != null ? 1 : 0
  input = {
    parameter02 = var.parameter02
  }
}

resource "terraform_data" "for_each_resource_example" {
  for_each = var.for_each_key_val
  input = {
    parameter03 = var.parameter03
  }
}
