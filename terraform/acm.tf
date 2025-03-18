resource "aws_acm_certificate" "app_certificate" {
  domain_name = var.host
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}