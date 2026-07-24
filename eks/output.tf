output "eks_cluster_endpoint" {
  value = aws_eks_cluster.ourzoo.endpoint
}

output "eks_cluster_things" {
  value = aws_eks_cluster.ourzoo
}


output "cluster_name" {
  value = aws_eks_cluster.ourzoo
}
