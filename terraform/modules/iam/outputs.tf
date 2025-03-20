output "github_actions_role" {
  description = "The GitHub Actions IAM role that can be used to deploy the application."
  value = aws_iam_role.github_actions_role.arn
}