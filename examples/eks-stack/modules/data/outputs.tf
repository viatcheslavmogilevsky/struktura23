output "partition" {
  value = data.aws_partition.this.partition
}

output "availability_zone_names" {
  value = data.aws_availability_zones.this.names
}

output "region_name" {
  value = data.aws_region.this.name
}
