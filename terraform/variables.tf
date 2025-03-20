variable "app_name" {
    description = "The application name you are deploying."
    type = string
}

variable "host" {
    description = "The host the application will be reachable from."
    type = string
}

variable "region" {
    description = "The AWS region the cluster will be deployed to."
    type = string
    default = "us-west-2"
}

variable "repository_name" {
    description = "The name of the ECR repository."
    type = string
}

variable "github_organization" {
    description = "The GitHub organization that owns the repository."
    type = string
}

variable "github_repository" {
    description = "The name of the GitHub repository deploying the application."
    type = string
}