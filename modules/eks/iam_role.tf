locals {
  oidc_provider_id = "57D021134F3726E753DD470D52F555C4"
}

resource "aws_iam_role" "alb_controller_role" {
  name = "alb-controller-role-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc_provider.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          "StringEquals" = {
            "oidc.eks.${var.region}.amazonaws.com/id/${local.oidc_provider_id}:sub" = "system:serviceaccount:kube-system:alb-controller-sa"
          }
        }
      }
    ]
  })

  tags = {
    Name    = "alb-controller-role"
    Project = var.project_tag
  }
}

