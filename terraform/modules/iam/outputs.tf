output "github_actions_role_arn" {
  description = "The GitHub Actions IAM role ARN that can be used to deploy the application."
  value = aws_iam_role.github_actions_role.arn
}