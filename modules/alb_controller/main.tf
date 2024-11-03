resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b2e729a3b3f27d9e5"]
  url             = var.oidc_issuer
}

resource "aws_iam_role" "alb_controller_role" {
  name = "alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_issuer}:sub" = "system:serviceaccount:kube-system:alb-sa"
          }
        }
      }
    ]
  })
}

resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "alb-sa"
    namespace = "kube-system"
  }

  automount_service_account_token = true
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.5.0" 
  timeout    = 600

  namespace  = "kube-system"

  depends_on = [kubernetes_service_account.alb_sa]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_sa.metadata[0].name
  }

  set {
    name  = "podLabels.app\\.kubernetes\\.io/component"
    value = "controller"
  }
}
