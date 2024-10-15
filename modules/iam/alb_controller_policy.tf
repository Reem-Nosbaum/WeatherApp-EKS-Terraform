resource "aws_iam_policy" "alb_controller_policy" {
  name        = "ALBIngressControllerIAMPolicy"
  description = "IAM policy for ALB ingress controller"
  policy      = file("${path.module}/alb_controller_policy.json")
}

# Attach the policy to your EKS node role
resource "aws_iam_role_policy_attachment" "alb_controller_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}
