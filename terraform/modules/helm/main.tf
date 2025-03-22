# resource "helm_release" "app" {
#   name = "app"
#   chart = "${path.root}/../helm/app"
#   version = "0.1.0"
#   depends_on = [helm_release.mysql, helm_release.redis]
# }

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