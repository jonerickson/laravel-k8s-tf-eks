resource "helm_release" "app" {
  name    = "app"
  chart   = "${path.root}/../helm/app"
  version = "0.1.0"
  depends_on = [helm_release.mysql, helm_release.redis, null_resource.check_docker_image_exists]

  set {
    name  = "image.repository"
    value = var.docker_image
  }

  set {
    name  = "image.tag"
    value = var.docker_image_tag
  }
}

resource "helm_release" "mysql" {
  name    = "mysql"
  chart   = "${path.root}/../helm/mysql"
  version = "0.1.0"
}

resource "helm_release" "redis" {
  name    = "redis"
  chart   = "${path.root}/../helm/redis"
  version = "0.1.0"
}

resource "null_resource" "check_docker_image_exists" {
  triggers = {
    docker_image = local.docker_image
  }

  provisioner "local-exec" {
    command = <<EOT
      aws ecr describe-images --repository-name ${var.docker_image_repository_name} --image-ids imageTag=${var.docker_image_tag} >/dev/null 2>&1
    EOT
  }
}

locals {
  docker_image = "${var.docker_image}:${var.docker_image_tag}"
}