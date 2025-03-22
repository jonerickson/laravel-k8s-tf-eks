variable "name" {
  description = "The name of the VPC."
  type        = string
}

variable "public_subnet_tags" {
  description = "A list of tags to apply to the public subnets."
  type = map(string)
}

variable "private_subnet_tags" {
  description = "A list of tags to apply to the private subnets."
  type = map(string)
}