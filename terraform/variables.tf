variable "app_name" {
    description = "The application name you are deploying."
    type = string
    default = "laravel-k8s-tf-eks"
}

variable "host" {
    description = "The host the application will be reachable from."
    type = string
    default = "laraveleks.deschutesdesigngroup.com"
}

variable "region" {
    description = "The AWS region the cluster will be deployed to."
    type = string
    default = "us-west-2"
}

variable "repository_name" {
    description = "The name of the ECR repository."
    type = string
    default = "laravel-k8s-tf-eks"
}
