resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn  # Use the cluster role passed from the root module
  version  = var.cluster_version
  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Name    = var.cluster_name
    Project = var.project_tag
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn  # Use the node role passed from the root module
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]

  tags = {
    Name    = "${var.cluster_name}-node-group"
    Project = var.project_tag
  }
}

data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = aws_eks_cluster.eks_cluster.name
}

# OIDC provider for EKS Cluster
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url            = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b2f5bb57e641ab8b6"]
}
