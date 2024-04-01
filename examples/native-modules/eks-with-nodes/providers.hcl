required_providers {
  aws = {
    source = "hashicorp/aws"
  }
  tls = {
    source  = "hashicorp/tls"
    version = ">= 4.0.4"
  }
}

# TBD: scanners needed to run scan over existing infra
# required_scanners {
#   aws = {
#     source = "..."
#   }
# }

