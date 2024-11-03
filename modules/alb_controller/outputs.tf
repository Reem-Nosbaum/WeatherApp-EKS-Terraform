output "alb_controller_iam_role" {
  description = "IAM Role used by the ALB Controller"
  value       = aws_iam_role.alb_controller_role.arn
}
