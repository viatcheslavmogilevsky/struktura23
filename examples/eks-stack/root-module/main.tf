module "data" {
  source = "../modules/data"
}

module "eks_cluster_iam_role" {
  source = "../modules/iam"

  role_name          = "EksCluster"
  assume_role_policy = module.data.eks_cluster_assume_role_policy_json
  custom_iam_policies = [{
    name            = "EksClusterCustomPolicy"
    description     = ""
    policy_document = module.data.eks_cluster_custom_policy_json
  }]

  managed_iam_policies = [
    format("arn:%s:iam::aws:policy/AmazonEKSClusterPolicy", module.data.partition),
    format("arn:%s:iam::aws:policy/AmazonEKSServicePolicy", module.data.partition),
  ]

  force_detach_policies = false
}

module "ec2_instance_worker_iam_role" {
  source = "../modules/iam"

  role_name          = "EksClusterWorker"
  assume_role_policy = module.data.ec2_instance_assume_role_policy_json
  custom_iam_policies = [{
    name            = "EksClusterWorkerCniPolicy"
    description     = ""
    policy_document = module.data.ec2_instance_custom_policy_json
  }]

  managed_iam_policies = [
    format("arn:%s:iam::aws:policy/AmazonEKSWorkerNodePolicy", module.data.partition),
    format("arn:%s:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", module.data.partition),
  ]
}

module "vpc" {
  source = "../modules/vpc"

  cidr                = "10.0.0.0/16"
  azs                 = slice(module.data.availability_zone_names, 0, 3)
  tags                = {}
  name                = "compute"
  public_subnet_tags  = { "kubernetes.io/role/elb" = "1" }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = "1" }
  single_nat_gateway  = true
}

module "eks" {
  source = "../modules/eks"
  # source = "../modules/eks-json"

  eks_cluster_name       = "test"
  eks_role_arn           = module.eks_cluster_iam_role.iam_role_arn
  eks_tags               = {}

  # NOTE: AZ-set cannot be changed
  eks_subnet_ids = flatten(
    [for az in ["us-west-2a", "us-west-2b"] : [module.vpc.public_subnet_az_mapping[az], module.vpc.private_subnet_az_mapping[az]]]
  )

  eks_security_group_ids = []

  # source = "../modules/eks-manually-generated"

  # eks_cluster_name     = "test"
  # eks_cluster_role_arn = module.eks_cluster_iam_role.iam_role_arn
  # eks_cluster_tags     = {}

  # eks_cluster_version  = "1.29"

  # eks_cluster_vpc_config = {
  #   # NOTE: AZ-set cannot be changed
  #   subnet_ids = flatten(
  #     [for az in ["us-west-2a", "us-west-2b"] : [module.vpc.public_subnet_az_mapping[az], module.vpc.private_subnet_az_mapping[az]]]
  #   )
  #   security_group_ids = []
  # }

  # eks_cluster_access_config = {}

  eks_node_role_arn                   = module.ec2_instance_worker_iam_role.iam_role_arn
  eks_node_group_name                 = "main"
  eks_node_group_desired_size         = 2
  eks_node_group_max_size             = 3
  eks_node_group_min_size             = 2
  eks_node_group_subnet_ids           = values(module.vpc.private_subnet_az_mapping)

  eks_node_group_capacity_type        = "SPOT"
  eks_node_group_labels               = {}
  eks_node_group_launch_template_name = "main"
  eks_node_group_instance_type        = "t4g.medium"

  eks_node_group_instance_types = [
    "a1.medium",
    "a1.large",
    "c6g.medium",
    "c6g.large",
    "c6gd.medium",
    "c6gd.large",
    "c6gn.medium",
    "c6gn.large",
    "c7g.medium",
    "c7g.large",
    "c7gd.medium",
    "c7gd.large",
    "c7gn.medium",
    "c7gn.large",
    "c8g.medium",
    "c8g.large",
    "m6g.medium",
    "m6gd.medium",
    "m7g.medium",
    "m7gd.medium",
    "m8g.medium",
  ]

  eks_node_group_ssh_key = null
}
