variable "docker_image" {
  description = "The Docker image to use for the application."
  type        = string
}

variable "docker_image_tag" {
  description = "The tag of the Docker image to use for the application."
  type        = string
  default     = "latest"
}

variable "docker_image_repository_name" {
  description = "The name of the ECR repository where the Docker image is stored."
  type        = string
}