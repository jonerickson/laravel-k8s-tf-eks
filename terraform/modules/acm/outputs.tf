output "dns_validation_records" {
    description = "The DNS validation records for the ACM certificate."
    value = aws_acm_certificate.app_certificate.domain_validation_options
}
