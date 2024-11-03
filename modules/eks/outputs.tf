output "eks_cluster_id" {
  value       = aws_eks_cluster.my_eks.id
  description = "The ID of the EKS cluster."
}

output "eks_node_group_id" {
  value       = aws_eks_node_group.my_node_group.id
  description = "The ID of the EKS node group."
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.my_eks.name
}

output "oidc_issuer" {
  description = "The OIDC provider URL"
  value       = aws_eks_cluster.my_eks.identity[0].oidc[0].issuer
}
