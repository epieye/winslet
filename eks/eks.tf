resource "aws_eks_cluster" "ourzoo" {
  name     = "ourzoo"
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.33" # version of kubernetes. https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html

  vpc_config {
    security_group_ids      = [aws_security_group.woznet-public-sg.id] # create one specifically for EKS in sg.tf
    subnet_ids              = [aws_subnet.woznet_subnet_public_1a.id, aws_subnet.woznet_subnet_public_1b.id, aws_subnet.woznet_subnet_public_1c.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     =  ["172.125.57.137/32", "32.141.185.206/32"] # home and office. Hos os this different from the security group?
  }
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_secrets_kms_key.arn
    }
    resources = ["secrets"]
  }

  #tags = var.tags

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  #depends_on = [
  #  aws_iam_role_policy_attachment.datascan-AmazonEKSClusterPolicy,
  #  aws_iam_role_policy_attachment.datascan-AmazonEKSServicePolicy,
  #]
}

#resource "kubernetes_service" "ourzoo-service" {
#  metadata {
#    name = "ourzoo-service"
#  }
#  spec {
#    selector = {
#      app = "${kubernetes_pod.ourzoo_pod.metadata.0.labels.app}"
#    }
#    session_affinity = "ClientIP"
#    port {
#      port        = 8080
#      target_port = 80
#    }
#
#    type = "LoadBalancer"
#  }
#}

## Error: Post "http://localhost/api/v1/namespaces/default/pods": dial tcp [::1]:80: connect: connection refused - why TF is is using localhost?
#resource "kubernetes_pod" "ourzoo_pod" {
#  metadata {
#    name = "ourzoo-pod"
#    labels = {
#      app = "MyApp"
#    }
#  }
#
#  spec {
#    container {
#      image = "nginx:1.7.9"
#      name  = "example"
#    }
#  }
#}

## Error: Post "http://localhost/api/v1/namespaces": dial tcp [::1]:80: connect: connection refused
#resource "kubernetes_namespace" "ourzoo-ns" {
#  metadata {
#    name = "ourzoo-ns"
#  }
#}

#resource "kubernetes_deployment" "my_app" {
#  metadata {
#    name      = "my-app-deployment"
#    namespace = kubernetes_namespace.ourzoo-ns.metadata[0].name
#  }
#  spec {
#    replicas = 3
#    selector {
#      match_labels = {
#        app = "my-app"
#      }
#    }
#    template {
#      metadata {
#        labels = {
#          app = "my-app"
#        }
#      }
#      spec {
#        container {
#          image = "nginx:latest"
#          name  = "nginx-container"
#          port {
#            container_port = 80
#          }
#        }
#      }
#    }
#  }
#}
