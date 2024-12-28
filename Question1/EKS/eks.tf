resource "aws_iam_role" "eks-cluster-role" {
  name = "${local.cluster_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = local.cluster_name
  version  = local.eks_version
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.private-subnet-1.id,
      aws_subnet.private-subnet-2.id
    ]
  }
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy_attachment]
}

resource "aws_iam_role" "nodes_role" {
  name = "nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_role.name
}
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_ro_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  version         = local.eks_version
  node_group_name = "general"
  node_role_arn   = aws_iam_role.nodes_role.arn

  subnet_ids = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.small"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_ro_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy
  ]
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
