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
